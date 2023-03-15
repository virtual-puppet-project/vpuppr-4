#include "abstract_tracker.h"

Error AbstractTracker::start(const Variant **p_args, GDExtensionInt p_arg_count, GDExtensionCallError &p_error) {
    logger->nyi("start");

    return ERR_METHOD_NOT_FOUND;
}

Error AbstractTracker::stop() {
    logger->nyi("stop");

    return ERR_METHOD_NOT_FOUND;
}

void AbstractTracker::_ready() {
    set_process(false);
}

void AbstractTracker::_exit_tree() {
    stop();
}

AbstractTracker::AbstractTracker() {
    logger = Logger::emplace("AbstractTracker");
}

AbstractTracker::~AbstractTracker() {}

void AbstractTracker::_bind_methods() {
    {
        MethodInfo mi;
        mi.name = "start";
        ClassDB::bind_vararg_method(METHOD_FLAG_VARARG, "start", &AbstractTracker::start, mi);
    }

    ClassDB::bind_method(D_METHOD("stop"), &AbstractTracker::stop);

    ADD_SIGNAL(MethodInfo(DATA_RECEIVED_SIGNAL, PropertyInfo(Variant::OBJECT, "data")));
}
