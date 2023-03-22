#ifndef TRACKER_CONTROLLER_H
#define TRACKER_CONTROLLER_H

#include <utils/logger.h>
#include <utils/trackers/abstract_tracker.h>

#include <godot_cpp/classes/node.hpp>
#include <godot_cpp/core/binder_common.hpp>

using namespace godot;

class TrackerController : public Node {
    GDCLASS(TrackerController, Node);

    static constexpr char *DATA_RECEIVED_SIGNAL = "data_received";

    Signal data_received;
    Ref<Logger> logger;

    // TODO godot typed arrays are buggy as hell
    Array trackers;

   protected:
    static void _bind_methods();

   public:
    Error subscribe(const Callable &p_callable);
    Error forget(const Callable &p_callable);

    Array get_trackers();

    Error add_tracker(const AbstractTracker *p_tracker);
    void remove_tracker(const AbstractTracker *p_tracker);

    void clear_trackers();

    TrackerController();
    ~TrackerController();
};

#endif  // TRACKER_CONTROLLER_H