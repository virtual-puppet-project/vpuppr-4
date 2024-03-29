#include "logger.h"

#include <godot_cpp/classes/time.hpp>
#include <godot_cpp/variant/utility_functions.hpp>

int log_store_max = 50;
std::vector<std::string> *log_store = new std::vector<std::string>();

void Logger::_add_to_log_store(const String &p_message) {
    log_store->push_back(std::string(p_message.utf8().get_data()));
    if (log_store->size() > log_store_max) {
        // TODO this is very inefficient
        log_store->erase(log_store->begin());
    }
}

String Logger::_insert_metadata(const String &p_message_id, const String &p_message) {
    Dictionary datetime = Time::get_singleton()->get_datetime_dict_from_system();

    Array arr;
    arr.append(p_message_id);
    arr.append(datetime["year"]);
    arr.append(datetime["month"]);
    arr.append(datetime["day"]);
    arr.append(datetime["hour"]);
    arr.append(datetime["minute"]);
    arr.append(datetime["second"]);
    arr.append(p_message);

    return String("{0} {1}-{2}-{3}_{4}:{5}:{6} {7}").format(arr);
}

void Logger::_log(const int p_type, const Variant &p_arg) {
    String formatted_message = _insert_metadata(logger_name, p_arg.stringify());

    String prefix;

    switch (p_type) {
        case NOTIFY:
            // TODO stub
            // Display some stuff and then fall through into INFO
        case INFO:
            prefix = String("[INFO] ");
            break;
        case WARN:
            prefix = String("[WARN] ");
            break;
        case DEBUG:
            prefix = String("[DEBUG] ");
            break;
        case TRACE:
            // TODO actually trace here
            prefix = String("[TRACE] ");
            break;
        case ERROR:
            prefix = String("[ERROR] ");
            break;
        default:
            Array arr;
            arr.append(formatted_message);
            arr.append(p_type);

            UtilityFunctions::printerr(String("Unexpected log type received:\nMessage: {0}\nType: {1}")
                                           .format(arr));
            break;
    }

    String final_message = prefix + formatted_message;

    UtilityFunctions::print(final_message);
    Logger::_add_to_log_store(final_message);
}

void Logger::_log_vararg(const Variant **p_args, GDExtensionInt p_arg_count, const int p_type) {
    String message;
    for (int i = 0; i < p_arg_count; i++) {
        message += (*(*p_args++)).stringify();
    }

    _log(p_type, message);
}

void Logger::set_logger_name(const String &p_logger_name) {
    logger_name = p_logger_name;
}

String Logger::get_logger_name() {
    return logger_name;
}

void Logger::notify(const int p_type, const Variant &p_arg) {
    // TODO mostly unimplemented
    _log(NOTIFY, p_arg);
}

void Logger::notify_vararg(const Variant **p_args, GDExtensionInt p_arg_count, GDExtensionCallError &p_error) {
    // TODO add notification stuff here

    if (p_arg_count < 2) {
        p_error.error = GDExtensionCallErrorType::GDEXTENSION_CALL_ERROR_TOO_FEW_ARGUMENTS;
        p_error.argument = 0;
        p_error.expected = 2;
        return;
    }

    Variant notify_type = *(*p_args++);

    _log_vararg(p_args, --p_arg_count, NOTIFY);
}

void Logger::info(const Variant &p_arg) {
    _log(INFO, p_arg);
}

void Logger::info_vararg(const Variant **p_args, GDExtensionInt p_arg_count, GDExtensionCallError &p_error) {
    _log_vararg(p_args, p_arg_count, INFO);
}

void Logger::warn(const Variant &p_arg) {
    _log(WARN, p_arg);
}

void Logger::warn_vararg(const Variant **p_args, GDExtensionInt p_arg_count, GDExtensionCallError &p_error) {
    _log_vararg(p_args, p_arg_count, WARN);
}

void Logger::debug(const Variant &p_arg) {
#ifdef DEBUG_ENABLED
    _log(DEBUG, p_arg);
#endif
}

void Logger::debug_vararg(const Variant **p_args, GDExtensionInt p_arg_count, GDExtensionCallError &p_error) {
#ifdef DEBUG_ENABLED
    _log_vararg(p_args, p_arg_count, DEBUG);
#endif
}

void Logger::trace(const Variant &p_arg) {
#ifdef DEBUG_ENABLED
    _log(TRACE, p_arg);
#endif
}

void Logger::trace_vararg(const Variant **p_args, GDExtensionInt p_arg_count, GDExtensionCallError &p_error) {
#ifdef DEBUG_ENABLED
    _log_vararg(p_args, p_arg_count, TRACE);
#endif
}

void Logger::error(const Variant &p_arg) {
    _log(ERROR, p_arg);
}

void Logger::error_vararg(const Variant **p_args, GDExtensionInt p_arg_count, GDExtensionCallError &p_error) {
    _log_vararg(p_args, p_arg_count, ERROR);
}

void Logger::global(const String &p_message_id, const String &p_message) {
    String final_message = String("[GLOBAL] " + _insert_metadata(p_message_id, p_message));

    UtilityFunctions::print(final_message);
    Logger::_add_to_log_store(final_message);
}

void Logger::nyi(const String &p_method_name) {
    global("NYI", p_method_name);
}

void Logger::set_log_store_max(const int p_max) {
    log_store_max = p_max;
}

TypedArray<String> Logger::get_logs() {
    TypedArray<String> arr;

    for (size_t i = 0; i < log_store->size(); i++) {
        std::string text = log_store->at(i);
        arr.push_back(String(text.c_str()));
    }

    return arr;
}

Ref<Logger> Logger::emplace(const String &p_logger_name) {
    Ref<Logger> logger;
    logger.instantiate();

    logger->set_logger_name(p_logger_name);

    return logger;
}

void Logger::_bind_methods() {
    ClassDB::bind_method(D_METHOD("set_logger_name", "name"), &Logger::set_logger_name);
    ClassDB::bind_method(D_METHOD("get_logger_name"), &Logger::get_logger_name);
    ADD_PROPERTY(PropertyInfo(Variant::STRING, "logger_name"), "set_logger_name", "get_logger_name");

    {
        MethodInfo mi;
        mi.arguments.push_back(PropertyInfo(Variant::INT, "type"));
        mi.arguments.push_back(PropertyInfo(Variant::NIL, "message"));
        mi.name = "notify";
        ClassDB::bind_vararg_method(METHOD_FLAG_VARARG, "notify", &Logger::notify_vararg, mi);
    }

    {
        MethodInfo mi;
        mi.arguments.push_back(PropertyInfo(Variant::NIL, "message"));
        mi.name = "info";
        ClassDB::bind_vararg_method(METHOD_FLAG_VARARG, "info", &Logger::info_vararg, mi);
    }

    {
        MethodInfo mi;
        mi.arguments.push_back(PropertyInfo(Variant::NIL, "message"));
        mi.name = "warn";
        ClassDB::bind_vararg_method(METHOD_FLAG_VARARG, "warn", &Logger::warn_vararg, mi);
    }

    {
        MethodInfo mi;
        mi.arguments.push_back(PropertyInfo(Variant::NIL, "message"));
        mi.name = "debug";
        ClassDB::bind_vararg_method(METHOD_FLAG_VARARG, "debug", &Logger::debug_vararg, mi);
    }

    {
        MethodInfo mi;
        mi.arguments.push_back(PropertyInfo(Variant::NIL, "message"));
        mi.name = "trace";
        ClassDB::bind_vararg_method(METHOD_FLAG_VARARG, "trace", &Logger::trace_vararg, mi);
    }

    {
        MethodInfo mi;
        mi.arguments.push_back(PropertyInfo(Variant::NIL, "message"));
        mi.name = "error";
        ClassDB::bind_vararg_method(METHOD_FLAG_VARARG, "error", &Logger::error_vararg, mi);
    }

    ClassDB::bind_static_method("Logger", D_METHOD("global", "message"), &Logger::global);
    ClassDB::bind_static_method("Logger", D_METHOD("set_log_store_max", "max"), &Logger::set_log_store_max);
    ClassDB::bind_static_method("Logger", D_METHOD("get_logs"), &Logger::get_logs);
    ClassDB::bind_static_method("Logger", D_METHOD("emplace", "logger_name"), &Logger::emplace);

    BIND_CONSTANT(NOTIFY);
    BIND_CONSTANT(INFO);
    BIND_CONSTANT(WARN);
    BIND_CONSTANT(DEBUG);
    BIND_CONSTANT(TRACE);
    BIND_CONSTANT(ERROR);

    BIND_ENUM_CONSTANT(TOAST);
    BIND_ENUM_CONSTANT(POPUP);
}
