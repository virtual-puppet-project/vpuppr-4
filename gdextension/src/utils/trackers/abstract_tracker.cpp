#include "abstract_tracker.h"

Error AbstractTracker::start(const Variant **p_args, GDExtensionInt p_arg_count, GDExtensionCallError &p_error) {
    _logger->nyi("start");

    return ERR_METHOD_NOT_FOUND;
}

Error AbstractTracker::stop(const Variant **p_args, GDExtensionInt p_arg_count, GDExtensionCallError &p_error) {
    _logger->nyi("stop");

    return ERR_METHOD_NOT_FOUND;
}

AbstractTracker::AbstractTracker() {
    _logger = Logger::emplace("AbstractTracker");
}

AbstractTracker::~AbstractTracker() {}

void AbstractTracker::_bind_methods() {
    {
        MethodInfo mi;
        mi.name = "start";
        ClassDB::bind_vararg_method(METHOD_FLAG_VARARG, "start", &AbstractTracker::start, mi);
    }

    {
        MethodInfo mi;
        mi.name = "stop";
        ClassDB::bind_vararg_method(METHOD_FLAG_VARARG, "stop", &AbstractTracker::stop, mi);
    }
}
