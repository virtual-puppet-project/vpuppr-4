#ifndef SAFELY_REGISTER_TYPES_H
#define SAFELY_REGISTER_TYPES_H

#include <godot_cpp/core/class_db.hpp>

using namespace godot;

void initialize_vpuppr_module(ModuleInitializationLevel p_level);
void uninitialize_vpuppr_module(ModuleInitializationLevel p_level);

#endif  // SAFELY_REGISTER_TYPES_H
