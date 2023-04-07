#include "meow_face.h"

#include <godot_cpp/classes/os.hpp>

void MeowFaceData::set_blend_shape(const String &p_name, const float &p_value) {
    blend_shapes[p_name] = p_value;
}

Dictionary MeowFaceData::get_blend_shapes() {
    return blend_shapes;
}

void MeowFaceData::set_head_rotation(const Dictionary &p_data) {
    head_rotation = Vector3((float)p_data["y"], (float)p_data["x"], (float)p_data["z"]);
}

Vector3 MeowFaceData::get_head_rotation() {
    return head_rotation;
}

void MeowFaceData::set_head_position(const Dictionary &p_data) {
    head_position = Vector3((float)p_data["y"], (float)p_data["x"], (float)p_data["z"]);
}

Vector3 MeowFaceData::get_head_position() {
    return head_position;
}

void MeowFaceData::set_left_eye_rotation(const Dictionary &p_data) {
    left_eye_rotation = Vector3(-(float)p_data["x"], -(float)p_data["y"], (float)p_data["z"]) / 100;
}

Vector3 MeowFaceData::get_left_eye_rotation() {
    return left_eye_rotation;
}

void MeowFaceData::set_right_eye_rotation(const Dictionary &p_data) {
    right_eye_rotation = Vector3(-(float)p_data["x"], -(float)p_data["y"], (float)p_data["z"]) / 100;
}

Vector3 MeowFaceData::get_right_eye_rotation() {
    return right_eye_rotation;
}

void MeowFaceData::parse(const Dictionary &p_data) {
    set_head_rotation(p_data.get("Rotation", _default_xyz()));
    set_head_position(p_data.get("Position", _default_xyz()));
    set_left_eye_rotation(p_data.get("EyeLeft", _default_xyz()));
    set_right_eye_rotation(p_data.get("EyeRight", _default_xyz()));

    Array blend_shapes = p_data.get("BlendShapes", Array());
    for (int i = 0; i < blend_shapes.size(); i++) {
        Dictionary data = blend_shapes[i];
        set_blend_shape(data["k"], data["v"]);
    }
}

MeowFaceData::MeowFaceData() {
}

MeowFaceData::~MeowFaceData() {}

void MeowFaceData::_bind_methods() {
    ClassDB::bind_method(D_METHOD("get_blend_shapes"), &MeowFaceData::get_blend_shapes);
    ADD_PROPERTY(PropertyInfo(Variant::DICTIONARY, "blend_shapes"), "", "get_blend_shapes");
    ClassDB::bind_method(D_METHOD("get_head_rotation"), &MeowFaceData::get_head_rotation);
    ADD_PROPERTY(PropertyInfo(Variant::VECTOR3, "head_rotation"), "", "get_head_rotation");
    ClassDB::bind_method(D_METHOD("get_head_position"), &MeowFaceData::get_head_position);
    ADD_PROPERTY(PropertyInfo(Variant::VECTOR3, "head_position"), "", "get_head_position");
    ClassDB::bind_method(D_METHOD("get_left_eye_rotation"), &MeowFaceData::get_left_eye_rotation);
    ADD_PROPERTY(PropertyInfo(Variant::VECTOR3, "left_eye_rotation"), "", "get_left_eye_rotation");
    ClassDB::bind_method(D_METHOD("get_right_eye_rotation"), &MeowFaceData::get_right_eye_rotation);
    ADD_PROPERTY(PropertyInfo(Variant::VECTOR3, "right_eye_rotation"), "", "get_right_eye_rotation");
}

Error MeowFace::_receive() {
    while (!stop_reception) {
        OS::get_singleton()->delay_msec(server_poll_interval);

        client->put_packet(_id_packet());

        if (client->get_available_packet_count() < 1) {
            continue;
        }
        if (client->get_packet_error() != OK) {
            logger->error(client->get_packet_error());
            continue;
        }

        PackedByteArray packet = client->get_packet();
        while (client->get_available_packet_count() > 0) {
            // TODO i feel like this could infinitely loop
            packet = client->get_packet();
        }
        if (packet.size() < 1) {
#ifdef DEBUG_ENABLED
            logger->debug("Received empty packet.");
#endif
            continue;
        }

        Variant data = JSON::parse_string(packet.get_string_from_utf8());
        if (data.get_type() != Variant::DICTIONARY) {
            logger->error("MeowFace data was not a Dictionary!");
            continue;
        }

        Ref<MeowFaceData> mf;
        mf.instantiate();

        mf->parse(data);

        emit_signal(DATA_RECEIVED_SIGNAL, mf);
    }

    return OK;
}

Error MeowFace::start(const Variant **p_args, GDExtensionInt p_arg_count, GDExtensionCallError &p_error) {
    if (!stop_reception || !receive_thread.is_null()) {
        logger->error("MeowFace is already running.");
        return ERR_DOES_NOT_EXIST;
    }

    logger->info("Starting receiver");

    stop_reception = false;

    String address = "";
    int port = -1;
    for (int i = 0; i < p_arg_count; i++) {
        switch (i) {
            case 0: {
                Variant v = (*(*p_args++));
                if (v.get_type() != Variant::STRING) {
                    logger->error("Parameter 1 should be a String.");
                    return ERR_INVALID_PARAMETER;
                }
                address = v;
                break;
            }
            case 1: {
                Variant v = (*(*p_args++));
                if (v.get_type() != Variant::INT) {
                    logger->error("Parameter 2 should be an int.");
                    return ERR_INVALID_PARAMETER;
                }
                port = v;
                break;
            }
            default: {
                Array arr;
                arr.append(p_arg_count);
                logger->error(String("Only expected 2 arguments for MeowFace, received {0}").format(arr));
                break;
            }
        }
    }

    ERR_FAIL_COND_V_MSG(address.is_empty(), ERR_CANT_CONNECT, "Address is empty");
    ERR_FAIL_COND_V_MSG(port < 1, ERR_CANT_CONNECT, "Port is invalid");

    client.instantiate();
    client->set_broadcast_enabled(true);
    client->set_dest_address(address, port);
    Error err = client->bind(port);
    if (err != OK) {
        logger->error("Failed to start client.");
        return ERR_BUG;
    }

    Callable receive_method = Callable(this, StringName("_receive"));
    if (!receive_method.is_valid()) {
        logger->error("Callable is not valid.");
        return ERR_BUG;
    }

    receive_thread.instantiate();
    err = receive_thread->start(receive_method);
    if (err != OK) {
        logger->error("Failed to start receive thread.");
        return ERR_BUG;
    }

    running = true;

    return OK;
}

Error MeowFace::stop() {
    if (stop_reception) {
        logger->error("MeowFace is not running.");
        return ERR_DOES_NOT_EXIST;
    }

    logger->info("Stopping MeowFace.");

    stop_reception = true;

    set_process(false);

    receive_thread->wait_to_finish();
    receive_thread.unref();

    client->close();
    client.unref();

    running = false;

    return OK;
}

StringName MeowFace::identifier() {
    return StringName("MeowFace");
}

MeowFace::MeowFace() : AbstractTracker() {
    logger->set_logger_name("MeowFace");

    server_poll_interval = 10;
    stop_reception = true;
}

MeowFace::~MeowFace() {}

void MeowFace::_bind_methods() {
    ClassDB::bind_method(D_METHOD("_receive"), &MeowFace::_receive);

    {
        MethodInfo mi;
        mi.name = "start";
        mi.arguments.push_back(PropertyInfo(Variant::STRING, "address"));
        mi.arguments.push_back(PropertyInfo(Variant::INT, "port"));
        ClassDB::bind_vararg_method(METHOD_FLAG_VARARG, "start", &MeowFace::start, mi);
    }
    ClassDB::bind_method(D_METHOD("stop"), &MeowFace::stop);

    ClassDB::bind_static_method("MeowFace", D_METHOD("identifier"), &MeowFace::meow_face_identifier);
}
