#include "abstract_tracker.h"

Error AbstractTracker::start(const Variant **p_args, GDExtensionInt p_arg_count, GDExtensionCallError &p_error) {
    logger->nyi("start");

    return ERR_METHOD_NOT_FOUND;
}

Error AbstractTracker::stop() {
    logger->nyi("stop");

    return ERR_METHOD_NOT_FOUND;
}

bool AbstractTracker::is_running() const {
    return running;
}

void AbstractTracker::_ready() {
    set_process(false);
}

void AbstractTracker::_exit_tree() {
    stop();
}

AbstractTracker::AbstractTracker() {
    logger = Logger::emplace("AbstractTracker");
    running = false;
}

AbstractTracker::~AbstractTracker() {}

StringName AbstractTracker::open_see_face_identifier() {
    return StringName("OpenSeeFace");
}

StringName AbstractTracker::meow_face_identifier() {
    return StringName("MeowFace");
}

StringName AbstractTracker::mediapipe_identifier() {
    return StringName("Mediapipe");
}

void AbstractTracker::_bind_methods() {
    {
        MethodInfo mi;
        mi.name = "start";
        ClassDB::bind_vararg_method(METHOD_FLAG_VARARG, "start", &AbstractTracker::start, mi);
    }
    ClassDB::bind_method(D_METHOD("stop"), &AbstractTracker::stop);

    ClassDB::bind_method(D_METHOD("is_running"), &AbstractTracker::is_running);

    ADD_SIGNAL(MethodInfo(DATA_RECEIVED_SIGNAL, PropertyInfo(Variant::OBJECT, "data")));
}
