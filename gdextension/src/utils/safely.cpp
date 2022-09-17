#include "safely.h"

#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/variant/utility_functions.hpp>

using namespace godot;

String SafeError::_to_string() {
    return String("hello");
}

SafeError::SafeError() {
    UtilityFunctions::print("SafeError created");
}

SafeError::~SafeError() {
    UtilityFunctions::print("SafeError destroyed");
}
