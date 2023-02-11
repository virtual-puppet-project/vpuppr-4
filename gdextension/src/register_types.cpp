#include "register_types.h"

#include <gdextension_interface.h>

#include <godot_cpp/classes/engine.hpp>
#include <godot_cpp/core/class_db.hpp>

#include "utils/logger.h"
#include "utils/trackers/abstract_tracker.h"
#include "utils/trackers/open_see_face.h"

using namespace godot;

void initialize_vpuppr_module(ModuleInitializationLevel p_level) {
    if (p_level != MODULE_INITIALIZATION_LEVEL_SCENE) {
        return;
    }
    ClassDB::register_class<Logger>();

    ClassDB::register_abstract_class<AbstractTracker>();
    ClassDB::register_class<OpenSeeFace>();
    ClassDB::register_class<OpenSeeFaceData>();
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
