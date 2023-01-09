#include "result.h"

String Tester::get_description() const {
    return description;
}

void Tester::set_description(const String &p_description) {
    description = p_description;
}

void Tester::_bind_methods() {
    ClassDB::bind_method(D_METHOD("get_description"), &Tester::get_description);
    ClassDB::bind_method(D_METHOD("set_description", "description"), &Tester::set_description);
    ADD_PROPERTY(PropertyInfo(Variant::STRING, "description", PropertyHint::PROPERTY_HINT_NONE, "", PROPERTY_USAGE_NO_EDITOR), "set_description", "get_description");
}

String ErrorResult::_to_string() {
    Array arr;
    arr.append(name.is_empty() ? String("") : String("Name: ") + name + String(" "));
    arr.append(code);
    arr.append(description);

    return String("Error - {0}Code: {1}, Description: {2}").format(arr);
}

String ErrorResult::get_name() const {
    return name;
}

void ErrorResult::set_name(const String &p_name) {
    name = p_name;
}

int ErrorResult::get_code() const {
    return code;
}

void ErrorResult::set_code(const int p_code) {
    code = p_code;
}

String ErrorResult::get_description() const {
    return description;
}

void ErrorResult::set_description(const String &p_description) {
    description = p_description;
}

ErrorResult::ErrorResult() {
    code = -1;
}

void ErrorResult::_bind_methods() {
    ClassDB::bind_method(D_METHOD("get_name"), &ErrorResult::get_name);
    ClassDB::bind_method(D_METHOD("set_name", "name"), &ErrorResult::set_name);
    ADD_PROPERTY(PropertyInfo(Variant::STRING, "name"), "set_name", "get_name");

    ClassDB::bind_method(D_METHOD("get_code"), &ErrorResult::get_code);
    ClassDB::bind_method(D_METHOD("set_code", "code"), &ErrorResult::set_code);
    ADD_PROPERTY(PropertyInfo(Variant::INT, "code"), "set_code", "get_code");

    ClassDB::bind_method(D_METHOD("get_description"), &ErrorResult::get_description);
    ClassDB::bind_method(D_METHOD("set_description", "description"), &ErrorResult::set_description);
    ADD_PROPERTY(PropertyInfo(Variant::STRING, "description"), "set_description", "get_description");
}

// Result *Result::register_error_codes(const Dictionary &p_error_codes, const bool p_is_enum) {
//     Array keys;
//     Array vals;

//     if (p_is_enum) {
//         keys = p_error_codes.keys();
//         vals = p_error_codes.values();
//     } else {
//         keys = p_error_codes.values();
//         vals = p_error_codes.keys();
//     }

//     for (int i = 0; i < keys.size(); i++) {
//         error_codes[vals[i]] = keys[i];
//     }

//     return ok(OK);
// }

Result *Result::ok(const Variant &p_variant) {
    ERR_FAIL_COND_V_MSG(
        p_variant.get_type() == Variant::NIL,
        err(ERR_INVALID_PARAMETER, "ok(...) must not contain null"),
        "ok(...) must not contain null");

    Result *r = memnew(Result());

    r->set_value(p_variant);

    return r;
}

Result *Result::err(const int p_code, const String &p_description) {
    Result *r = memnew(Result());

    ErrorResult *e = memnew(ErrorResult());
    e->set_name("");
    e->set_code(p_code);
    e->set_description(p_description);

    r->set_value(Variant(e));
    r->set_is_error(true);

    return r;
}

void Result::set_is_error(const bool p_is_error) {
    is_error = p_is_error;
}

Variant Result::get_value() {
    return value;
}

void Result::set_value(const Variant &p_variant) {
    value = p_variant;
}

Variant Result::unwrap() {
    ERR_FAIL_COND_V(is_err(), Variant());

    return value;
}

Variant Result::unwrap_err() {
    ERR_FAIL_COND_V(is_ok(), Variant());

    return value;
}

void Result::_bind_methods() {
    ClassDB::bind_method(D_METHOD("get_value"), &Result::get_value);
    ClassDB::bind_method(D_METHOD("set_value", "value"), &Result::set_value);

    ClassDB::bind_method(D_METHOD("unwrap"), &Result::unwrap);
    ClassDB::bind_method(D_METHOD("unwrap_err"), &Result::unwrap_err);

    ClassDB::bind_method(D_METHOD("is_ok"), &Result::is_ok);
    ClassDB::bind_method(D_METHOD("is_err"), &Result::is_err);

    // ClassDB::bind_static_method("Result", D_METHOD("register_error_codes", "error_codes", "is_enum"), &Result::register_error_codes);
    ClassDB::bind_static_method("Result", D_METHOD("ok", "value"), &Result::ok, DEFVAL(OK));
    ClassDB::bind_static_method("Result", D_METHOD("err", "code", "description"), &Result::err);
}
