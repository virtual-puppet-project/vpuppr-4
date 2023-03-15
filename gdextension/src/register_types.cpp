#include "register_types.h"

#include <gdextension_interface.h>
#include <utils/logger.h>
#include <utils/tracker_controller.h>
#include <utils/trackers/abstract_tracker.h>
#include <utils/trackers/meow_face.h>
#include <utils/trackers/open_see_face.h>

#include <godot_cpp/classes/engine.hpp>
#include <godot_cpp/core/class_db.hpp>

using namespace godot;

void initialize_vpuppr_module(ModuleInitializationLevel p_level) {
    if (p_level != MODULE_INITIALIZATION_LEVEL_SCENE) {
        return;
    }
    ClassDB::register_class<Logger>();

    // TODO cannot register AbstractTracker as an abstract class, otherwise OpenSeeFace cannot be constructed
    ClassDB::register_class<AbstractTracker>();
    ClassDB::register_class<OpenSeeFace>();
    ClassDB::register_class<OpenSeeFaceData>();
    ClassDB::register_class<MeowFace>();
    ClassDB::register_class<MeowFaceData>();

    ClassDB::register_class<TrackerController>();
}

void uninitialize_vpuppr_module(ModuleInitializationLevel p_level) {
    if (p_level != MODULE_INITIALIZATION_LEVEL_SCENE) {
        return;
    }
}

extern "C" {
GDExtensionBool GDE_EXPORT vpuppr_library_init(const GDExtensionInterface *p_interface, const GDExtensionClassLibraryPtr p_library, GDExtensionInitialization *r_initialization) {
    godot::GDExtensionBinding::InitObject init_obj(p_interface, p_library, r_initialization);

    init_obj.register_initializer(initialize_vpuppr_module);
    init_obj.register_terminator(uninitialize_vpuppr_module);
    init_obj.set_minimum_library_initialization_level(MODULE_INITIALIZATION_LEVEL_SCENE);

    return init_obj.init();
}
}
