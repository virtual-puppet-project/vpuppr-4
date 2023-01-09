#ifndef RESULT_H
#define RESULT_H

#include <godot_cpp/classes/node.hpp>
#include <godot_cpp/classes/ref_counted.hpp>

using namespace godot;

class Tester : public Node {
    GDCLASS(Tester, Node);

    String description;

   protected:
    static void _bind_methods();

   public:
    String get_description() const;
    void set_description(const String &p_name);

    Tester() {}
    ~Tester() {}
};

class ErrorResult : public RefCounted {
    GDCLASS(ErrorResult, RefCounted);

    String name;
    int code;
    String description;

   protected:
    static void _bind_methods();
    String _to_string();

   public:
    String get_name() const;
    void set_name(const String &p_name);

    int get_code() const;
    void set_code(const int p_code);

    String get_description() const;
    void set_description(const String &p_description);

    ErrorResult();
    ~ErrorResult() {}
};

class Result : public RefCounted {
    GDCLASS(Result, RefCounted);

    Variant value;
    bool is_error = false;

   private:
    void set_is_error(const bool p_is_error);

   protected:
    static void _bind_methods();

   public:
    // static Result *register_error_codes(const Dictionary &p_error_codes, const bool p_is_enum = true);
    static Result *ok(const Variant &p_variant = Variant(OK));
    static Result *err(const int p_code, const String &p_description);

    _FORCE_INLINE_ bool is_ok() const {
        return !is_err();
    }

    _FORCE_INLINE_ bool is_err() const {
        return is_error;
    }

    Variant get_value();
    void set_value(const Variant &p_variant);

    Variant unwrap();
    Variant unwrap_err();

    Result() {}
    ~Result() {}
};

#endif  // RESULT_H
