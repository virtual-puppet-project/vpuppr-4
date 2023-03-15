#include "tracker_controller.h"

#include <godot_cpp/variant/utility_functions.hpp>

Error TrackerController::subscribe(const Callable &p_callable) {
    if (data_received.is_connected(p_callable)) {
        return ERR_ALREADY_IN_USE;
    }
    data_received.connect(p_callable);

    return OK;
}

Error TrackerController::forget(const Callable &p_callable) {
    if (data_received.is_connected(p_callable)) {
        return ERR_CONNECTION_ERROR;
    }
    data_received.disconnect(p_callable);

    return OK;
}

Array TrackerController::get_trackers() {
    return trackers;
}

Error TrackerController::add_tracker(const AbstractTracker *p_tracker) {
    if (trackers.has(p_tracker)) {
        return ERR_ALREADY_EXISTS;
    }
    trackers.push_back(p_tracker);

    return OK;
}

void TrackerController::remove_tracker(const AbstractTracker *p_tracker) {
    trackers.erase(p_tracker);
}

void TrackerController::clear_trackers() {
    for (int i = 0; i < trackers.size() - 1; i++) {
        Variant tracker = trackers[i];
        // In theory, a tracker can be deleted at anytime
        // In practice, this should never happen
        if (!UtilityFunctions::is_instance_valid(tracker)) {
            logger->error("Invalid tracker was present in TrackerController");
            continue;
        }
        AbstractTracker *tracker_instance = static_cast<AbstractTracker *>(static_cast<Object *>(tracker));
        tracker_instance->stop();
        tracker_instance->queue_free();
    }

    trackers.clear();
}

TrackerController::TrackerController() {
    data_received = Signal(this, DATA_RECEIVED_SIGNAL);
    logger = Logger::emplace("TrackerController");
    trackers = Array();
}

TrackerController::~TrackerController() {}

void TrackerController::_bind_methods() {
    ClassDB::bind_method(D_METHOD("subscribe", "callback"), &TrackerController::subscribe);
    ClassDB::bind_method(D_METHOD("forget", "callback"), &TrackerController::forget);

    ClassDB::bind_method(D_METHOD("get_trackers"), &TrackerController::get_trackers);
    ADD_PROPERTY(PropertyInfo(Variant::OBJECT, "trackers"), "", "get_trackers");

    ClassDB::bind_method(D_METHOD("add_tracker", "tracker"), &TrackerController::add_tracker);
    ClassDB::bind_method(D_METHOD("remove_tracker", "tracker"), &TrackerController::remove_tracker);

    ADD_SIGNAL(MethodInfo(DATA_RECEIVED_SIGNAL, PropertyInfo(Variant::OBJECT, "data")));
}
