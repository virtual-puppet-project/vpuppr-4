#ifndef ABSTRACT_TRACKER_H
#define ABSTRACT_TRACKER_H

#include <godot_cpp/classes/node.hpp>
#include <godot_cpp/core/binder_common.hpp>

#include "../logger.h"

using namespace godot;

class AbstractTracker : public Node {
    GDCLASS(AbstractTracker, Node);

   private:
    Ref<Logger> _logger;

   protected:
    static void _bind_methods();

   public:
    virtual Error start(const Variant **p_args, GDExtensionInt p_arg_count, GDExtensionCallError &p_error);
    virtual Error stop(const Variant **p_args, GDExtensionInt p_arg_count, GDExtensionCallError &p_error);

    AbstractTracker();
    ~AbstractTracker();
};

#endif  // ABSTRACT_TRACKER_H