#include "mediapipe.h"

#include <godot_cpp/classes/json.hpp>
#include <godot_cpp/classes/os.hpp>
#include <godot_cpp/variant/utility_functions.hpp>

Error Mediapipe::_receive() {
    while (!stop_reception) {
        OS::get_singleton()->delay_msec(SERVER_POLL_DELAY);

        if (server->poll() != OK) {
            logger->error("Error occurred while polling Mediapipe.");
            continue;
        }

        if (!connection.is_null()) {
            PackedByteArray packet = connection->get_packet();
            Variant data = JSON::parse_string(packet.get_string_from_utf8());

            if (data.get_type() != Variant::DICTIONARY) {
                logger->error("Unexpected data from mediapipe.");
                return ERR_INVALID_DATA;
            }

            // TODO this might explode?
            Dictionary dict = data;

            Basis basis = Basis(
                Vector3(((double)((Array)dict["x"])[0]), ((double)((Array)dict["x"])[1]), ((double)((Array)dict["x"])[2])),
                Vector3(((double)((Array)dict["y"])[0]), ((double)((Array)dict["y"])[1]), ((double)((Array)dict["y"])[2])),
                Vector3(((double)((Array)dict["z"])[0]), ((double)((Array)dict["z"])[1]), ((double)((Array)dict["z"])[2])));

            UtilityFunctions::print(basis);

        } else if (server->is_connection_available()) {
            logger->debug("Taking connection");
            connection = server->take_connection();
        }
    }

    return OK;
}

Error Mediapipe::start(const Variant **p_args, GDExtensionInt p_arg_count, GDExtensionCallError &p_error) {
    logger->info("Starting Mediapipe");

    if (!receive_thread.is_null()) {
        logger->error("Receive thread is still running.");
        return ERR_ALREADY_IN_USE;
    }

    server.instantiate();
    // TODO pull values from args or config
    Error err = server->listen(8787, "127.0.0.1");
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

Error Mediapipe::stop() {
    if (stop_reception) {
        logger->error("Mediapipe is not running.");
        return ERR_DOES_NOT_EXIST;
    }
    logger->info(String("Stopping Mediapipe."));

    stop_reception = true;

    set_process(false);

    receive_thread->wait_to_finish();
    receive_thread.unref();

    connection->close();
    connection.unref();

    running = false;

    return OK;
}

StringName Mediapipe::identifier() {
    return StringName("Mediapipe");
}

Mediapipe::Mediapipe() {
    logger->set_logger_name(Mediapipe::mediapipe_identifier());

    receive_pid = -1;
    stop_reception = true;
}

Mediapipe::~Mediapipe() {
}

void Mediapipe::_bind_methods() {
    ClassDB::bind_method(D_METHOD("_receive"), &Mediapipe::_receive);

    {
        MethodInfo mi;
        mi.name = "start";
        mi.default_arguments.push_back(Variant(0));
        ClassDB::bind_vararg_method(METHOD_FLAG_VARARG, "start", &Mediapipe::start, mi);
    }
    ClassDB::bind_method(D_METHOD("stop"), &Mediapipe::stop);

    ClassDB::bind_static_method("Mediapipe", D_METHOD("identifier"), &Mediapipe::mediapipe_identifier);
}
