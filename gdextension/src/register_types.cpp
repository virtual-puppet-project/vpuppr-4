#include "register_types.h"

#include <godot/gdnative_interface.h>

#include <godot_cpp/classes/engine.hpp>
#include <godot_cpp/core/class_db.hpp>

#include "model/result.h"
#include "utils/logger.h"

using namespace godot;

void initialize_vpuppr_module(ModuleInitializationLevel p_level) {
    if (p_level != MODULE_INITIALIZATION_LEVEL_SCENE) {
        return;
    }
    ClassDB::register_class<Logger>();
    ClassDB::register_class<Result>();
    ClassDB::register_class<ErrorResult>();
}

void uninitialize_vpuppr_module(ModuleInitializationLevel p_level) {
    if (p_level != MODULE_INITIALIZATION_LEVEL_SCENE) {
        return;
    }
}

extern "C" {
GDNativeBool GDN_EXPORT vpuppr_library_init(const GDNativeInterface *p_interface, const GDNativeExtensionClassLibraryPtr p_library, GDNativeInitialization *r_initialization) {
    godot::GDExtensionBinding::InitObject init_obj(p_interface, p_library, r_initialization);

    init_obj.register_initializer(initialize_vpuppr_module);
    init_obj.register_terminator(uninitialize_vpuppr_module);
    init_obj.set_minimum_library_initialization_level(MODULE_INITIALIZATION_LEVEL_SCENE);

    return init_obj.init();
}
}
