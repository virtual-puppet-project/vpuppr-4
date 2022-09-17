#ifndef SAFELY_H
#define SAFELY_H

#include <godot_cpp/classes/ref_counted.hpp>

using namespace godot;

class SafeError : public RefCounted {
    GDCLASS(SafeError, RefCounted);

   protected:
    static void _bind_methods() {}
    String _to_string();

   public:
    // String get_name() const;
    // void set_name(const String &p_name);

    // int get_code() const;
    // void set_code(const int p_code);

    // String get_description() const;
    // void set_description(const String &p_description);

    SafeError();
    ~SafeError();
};

#endif  // SAFELY_H
