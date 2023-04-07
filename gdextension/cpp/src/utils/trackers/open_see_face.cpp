#include "open_see_face.h"

float OpenSeeFaceData::get_time() {
    return time;
}

int OpenSeeFaceData::get_id() {
    return id;
}

Vector2i OpenSeeFaceData::get_camera_resolution() {
    return camera_resolution;
}

float OpenSeeFaceData::get_right_eye_open() {
    return right_eye_open;
}

float OpenSeeFaceData::get_left_eye_open() {
    return left_eye_open;
}

Quaternion OpenSeeFaceData::get_right_gaze() {
    return right_gaze;
}

Quaternion OpenSeeFaceData::get_left_gaze() {
    return left_gaze;
}

bool OpenSeeFaceData::get_got_3d_points() {
    return got_3d_points;
}

float OpenSeeFaceData::get_fit_3d_error() {
    return fit_3d_error;
}

Vector3 OpenSeeFaceData::get_rotation() {
    return rotation;
}

Vector3 OpenSeeFaceData::get_translation() {
    return translation;
}

Quaternion OpenSeeFaceData::get_raw_quaternion() {
    return raw_quaternion;
}

Vector3 OpenSeeFaceData::get_raw_euler() {
    return raw_euler;
}

PackedFloat32Array OpenSeeFaceData::get_confidence() {
    return confidence;
}

PackedVector2Array OpenSeeFaceData::get_points() {
    return points;
}

PackedVector3Array OpenSeeFaceData::get_points_3d() {
    return points_3d;
}

float OpenSeeFaceData::get_eye_left() {
    return eye_left;
}

float OpenSeeFaceData::get_eye_right() {
    return eye_right;
}

float OpenSeeFaceData::get_eyebrow_steepness_left() {
    return eyebrow_steepness_left;
}

float OpenSeeFaceData::get_eyebrow_up_down_left() {
    return eyebrow_up_down_left;
}

float OpenSeeFaceData::get_eyebrow_quirk_left() {
    return eyebrow_quirk_left;
}

float OpenSeeFaceData::get_eyebrow_steepness_right() {
    return eyebrow_steepness_right;
}

float OpenSeeFaceData::get_eyebrow_up_down_right() {
    return eyebrow_up_down_right;
}

float OpenSeeFaceData::get_eyebrow_quirk_right() {
    return eyebrow_quirk_right;
}

float OpenSeeFaceData::get_mouth_corner_up_down_left() {
    return mouth_corner_up_down_left;
}

float OpenSeeFaceData::get_mouth_corner_in_out_left() {
    return mouth_corner_in_out_left;
}

float OpenSeeFaceData::get_mouth_corner_up_down_right() {
    return mouth_corner_up_down_right;
}

float OpenSeeFaceData::get_mouth_corner_in_out_right() {
    return mouth_corner_in_out_right;
}

float OpenSeeFaceData::get_mouth_open() {
    return mouth_open;
}

float OpenSeeFaceData::get_mouth_wide() {
    return mouth_wide;
}

void OpenSeeFaceData::read_packet(const PackedByteArray &b) {
    Ref<StreamPeerBuffer> spb;
    spb.instantiate();

    spb->set_data_array(b);

    time = spb->get_double();
    id = spb->get_float();

    camera_resolution = _read_vector2(spb);

    right_eye_open = spb->get_float();
    left_eye_open = spb->get_float();

    if (spb->get_8() != 0) {
        got_3d_points = true;
    }
    fit_3d_error = spb->get_float();

    raw_quaternion = _read_quaternion(spb);
    raw_euler = _read_vector3(spb);

    rotation = raw_euler;
    if (rotation.x <= 0.0) {
        rotation.x += 360.0;
    }

    {
        float x = spb->get_float();
        float y = spb->get_float();
        float z = spb->get_float();

        translation = -Vector3(y, x, z);
    }

    for (int i = 0; i < NUMBER_OF_POINTS; i++) {
        confidence.set(i, spb->get_float());
    }
    for (int i = 0; i < NUMBER_OF_POINTS; i++) {
        points.set(i, _read_vector2(spb));
    }
    for (int i = 0; i < NUMBER_OF_POINTS + 2; i++) {
        points_3d.set(i, _read_vector3(spb));
    }

    right_gaze = Quaternion(Transform3D().looking_at(points_3d[66] - points_3d[68], Vector3(0, 1, 0)).basis).normalized();
    left_gaze = Quaternion(Transform3D().looking_at(points_3d[67] - points_3d[69], Vector3(0, 1, 0)).basis).normalized();

    eye_left = spb->get_float();
    eye_right = spb->get_float();

    eyebrow_steepness_left = spb->get_float();
    eyebrow_up_down_left = spb->get_float();
    eyebrow_quirk_left = spb->get_float();

    eyebrow_steepness_right = spb->get_float();
    eyebrow_up_down_right = spb->get_float();
    eyebrow_quirk_right = spb->get_float();

    mouth_corner_up_down_left = spb->get_float();
    mouth_corner_in_out_left = spb->get_float();

    mouth_corner_up_down_right = spb->get_float();
    mouth_corner_in_out_right = spb->get_float();

    mouth_open = spb->get_float();
    mouth_wide = spb->get_float();
}

OpenSeeFaceData::OpenSeeFaceData() {
    time = 0.0;
    id = 0;

    camera_resolution = Vector2i();

    right_eye_open = 0.0;
    left_eye_open = 0.0;

    right_gaze = Quaternion();
    left_gaze = Quaternion();

    got_3d_points = false;
    fit_3d_error = 0.0;

    rotation = Vector3();
    translation = Vector3();

    raw_quaternion = Quaternion();
    raw_euler = Vector3();

    confidence = PackedFloat32Array();
    confidence.resize(NUMBER_OF_POINTS);
    points = PackedVector2Array();
    points.resize(NUMBER_OF_POINTS);
    points_3d = PackedVector3Array();
    points_3d.resize(NUMBER_OF_POINTS + 2);
}

OpenSeeFaceData::~OpenSeeFaceData() {}

void OpenSeeFaceData::_bind_methods() {
    ClassDB::bind_method(D_METHOD("get_time"), &OpenSeeFaceData::get_time);
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "time"), "", "get_time");
    ClassDB::bind_method(D_METHOD("get_id"), &OpenSeeFaceData::get_id);
    ADD_PROPERTY(PropertyInfo(Variant::INT, "id"), "", "get_id");

    ClassDB::bind_method(D_METHOD("get_camera_resolution"), &OpenSeeFaceData::get_camera_resolution);
    ADD_PROPERTY(PropertyInfo(Variant::VECTOR2I, "camera_resolution"), "", "get_camera_resolution");

    ClassDB::bind_method(D_METHOD("get_right_gaze"), &OpenSeeFaceData::get_right_gaze);
    ADD_PROPERTY(PropertyInfo(Variant::QUATERNION, "right_gaze"), "", "get_right_gaze");
    ClassDB::bind_method(D_METHOD("get_left_gaze"), &OpenSeeFaceData::get_left_gaze);
    ADD_PROPERTY(PropertyInfo(Variant::QUATERNION, "left_gaze"), "", "get_left_gaze");

    ClassDB::bind_method(D_METHOD("get_got_3d_points"), &OpenSeeFaceData::get_got_3d_points);
    ADD_PROPERTY(PropertyInfo(Variant::BOOL, "got_3d_points"), "", "get_got_3d_points");
    ClassDB::bind_method(D_METHOD("get_fit_3d_error"), &OpenSeeFaceData::get_fit_3d_error);
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "fit_3d_error"), "", "get_fit_3d_error");

    ClassDB::bind_method(D_METHOD("get_rotation"), &OpenSeeFaceData::get_rotation);
    ADD_PROPERTY(PropertyInfo(Variant::VECTOR3, "rotation"), "", "get_rotation");
    ClassDB::bind_method(D_METHOD("get_translation"), &OpenSeeFaceData::get_translation);
    ADD_PROPERTY(PropertyInfo(Variant::VECTOR3, "translation"), "", "get_translation");

    ClassDB::bind_method(D_METHOD("get_raw_quaternion"), &OpenSeeFaceData::get_raw_quaternion);
    ADD_PROPERTY(PropertyInfo(Variant::QUATERNION, "raw_quaternion"), "", "get_raw_quaternion");
    ClassDB::bind_method(D_METHOD("get_raw_euler"), &OpenSeeFaceData::get_raw_euler);
    ADD_PROPERTY(PropertyInfo(Variant::VECTOR3, "raw_euler"), "", "get_raw_euler");

    ClassDB::bind_method(D_METHOD("get_confidence"), &OpenSeeFaceData::get_confidence);
    ADD_PROPERTY(PropertyInfo(Variant::PACKED_FLOAT32_ARRAY, "confidence"), "", "get_confidence");
    ClassDB::bind_method(D_METHOD("get_points"), &OpenSeeFaceData::get_points);
    ADD_PROPERTY(PropertyInfo(Variant::PACKED_VECTOR2_ARRAY, "points"), "", "get_points");
    ClassDB::bind_method(D_METHOD("get_points_3d"), &OpenSeeFaceData::get_points_3d);
    ADD_PROPERTY(PropertyInfo(Variant::PACKED_VECTOR3_ARRAY, "points_3d"), "", "get_points_3d");

    ClassDB::bind_method(D_METHOD("get_eye_left"), &OpenSeeFaceData::get_eye_left);
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "eye_left"), "", "get_eye_left");
    ClassDB::bind_method(D_METHOD("get_eye_right"), &OpenSeeFaceData::get_eye_right);
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "eye_right"), "", "get_eye_right");

    ClassDB::bind_method(D_METHOD("get_eyebrow_steepness_left"), &OpenSeeFaceData::get_eyebrow_steepness_left);
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "eyebrow_steepness_left"), "", "get_eyebrow_steepness_left");
    ClassDB::bind_method(D_METHOD("get_eyebrow_up_down_left"), &OpenSeeFaceData::get_eyebrow_up_down_left);
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "eyebrow_up_down_left"), "", "get_eyebrow_up_down_left");
    ClassDB::bind_method(D_METHOD("get_eyebrow_quirk_left"), &OpenSeeFaceData::get_eyebrow_quirk_left);
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "eyebrow_quirk_left"), "", "get_eyebrow_quirk_left");

    ClassDB::bind_method(D_METHOD("get_eyebrow_steepness_right"), &OpenSeeFaceData::get_eyebrow_steepness_right);
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "eyebrow_steepness_right"), "", "get_eyebrow_steepness_right");
    ClassDB::bind_method(D_METHOD("get_eyebrow_up_down_right"), &OpenSeeFaceData::get_eyebrow_up_down_right);
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "eyebrow_up_down_right"), "", "get_eyebrow_up_down_right");
    ClassDB::bind_method(D_METHOD("get_eyebrow_quirk_right"), &OpenSeeFaceData::get_eyebrow_quirk_right);
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "eyebrow_quirk_right"), "", "get_eyebrow_quirk_right");

    ClassDB::bind_method(D_METHOD("get_mouth_corner_up_down_left"), &OpenSeeFaceData::get_mouth_corner_up_down_left);
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "mouth_corner_up_down_left"), "", "get_mouth_corner_up_down_left");
    ClassDB::bind_method(D_METHOD("get_mouth_corner_in_out_left"), &OpenSeeFaceData::get_mouth_corner_in_out_left);
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "mouth_corner_in_out_left"), "", "get_mouth_corner_in_out_left");

    ClassDB::bind_method(D_METHOD("get_mouth_corner_up_down_right"), &OpenSeeFaceData::get_mouth_corner_up_down_right);
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "mouth_corner_up_down_right"), "", "get_mouth_corner_up_down_right");
    ClassDB::bind_method(D_METHOD("get_mouth_corner_in_out_right"), &OpenSeeFaceData::get_mouth_corner_in_out_right);
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "mouth_corner_in_out_right"), "", "get_mouth_corner_in_out_right");

    ClassDB::bind_method(D_METHOD("get_mouth_open"), &OpenSeeFaceData::get_mouth_open);
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "mouth_open"), "", "get_mouth_open");
    ClassDB::bind_method(D_METHOD("get_mouth_wide"), &OpenSeeFaceData::get_mouth_wide);
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "mouth_wide"), "", "get_mouth_wide");
}

void OpenSeeFace::_process(double delta) {
    poll_counter += delta;
    if (poll_counter > SERVER_POLL_INTERVAL) {
        should_poll = true;
        poll_counter = 0.0;
    }
}

Error OpenSeeFace::_receive() {
    while (!stop_reception) {
        if (!should_poll) {
            continue;
        }
        should_poll = false;

        if (server->poll() != OK) {
            logger->error(String("Error occurred while polling OpenSeeFace."));
            continue;
        }

        if (!connection.is_null()) {
            PackedByteArray packet = connection->get_packet();
            if (packet.size() < 1 || packet.size() % PACKET_FRAME_SIZE != 0) {
                logger->error("Failed to receive packet from OpenSeeFace");
                continue;
            }

            Ref<OpenSeeFaceData> data;
            data.instantiate();

            logger->debug("Reading packet");

            data->read_packet(packet);

            logger->debug("Finished reading packet");

            emit_signal(DATA_RECEIVED_SIGNAL, data);
        } else if (server->is_connection_available()) {
            logger->debug("Taking connection");
            connection = server->take_connection();
        }
    }

    return OK;
}

Error OpenSeeFace::start(const Variant **p_args, GDExtensionInt p_arg_count, GDExtensionCallError &p_error) {
    logger->info(String("Starting OpenSeeFace"));

    if (!receive_thread.is_null()) {
        logger->error("Receive thread is still running");
        return ERR_ALREADY_IN_USE;
    }

    server.instantiate();
    // TODO pull these values from either args or config
    Error err = server->listen(11573, String("127.0.0.1"));
    if (err != OK) {
        logger->error("Server failed to start.");
        return err;
    }

    stop_reception = false;

    Callable receive_method = Callable(this, StringName("_receive"));
    if (!receive_method.is_valid()) {
        logger->error("Callable is not valid.");
        return ERR_BUG;
    }

    receive_thread.instantiate();
    err = receive_thread->start(receive_method);
    if (err != OK) {
        logger->error("Thread failed to start.");
        return err;
    }

    set_process(true);

    running = true;

    return OK;
}

Error OpenSeeFace::stop() {
    if (stop_reception) {
        logger->error("OpenSeeFace is not running.");
        return ERR_DOES_NOT_EXIST;
    }
    logger->info(String("Stopping OpenSeeFace"));

    stop_reception = true;

    set_process(false);

    poll_counter = 0.0;
    should_poll = false;

    receive_thread->wait_to_finish();
    receive_thread.unref();

    connection->close();
    connection.unref();

    running = false;

    return OK;
}

OpenSeeFace::OpenSeeFace() : AbstractTracker() {
    logger->set_logger_name("OpenSeeFace");

    receive_pid = -1;
    stop_reception = true;
    should_poll = false;
    poll_counter = 0.0;
}

OpenSeeFace::~OpenSeeFace() {}

void OpenSeeFace::_bind_methods() {
    ClassDB::bind_method(D_METHOD("_receive"), &OpenSeeFace::_receive);

    {
        MethodInfo mi;
        mi.name = "start";
        mi.default_arguments.push_back(Variant(0));
        ClassDB::bind_vararg_method(METHOD_FLAG_VARARG, "start", &OpenSeeFace::start, mi);
    }
    ClassDB::bind_method(D_METHOD("stop"), &OpenSeeFace::stop);

    ClassDB::bind_static_method("OpenSeeFace", D_METHOD("identifier"), &OpenSeeFace::open_see_face_identifier);
}
