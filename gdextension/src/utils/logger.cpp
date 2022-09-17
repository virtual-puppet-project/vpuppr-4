#include "logger.h"

#include <godot_cpp/classes/time.hpp>
#include <godot_cpp/variant/utility_functions.hpp>

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

void Logger::_log(const String &p_message, const int p_type) {
    String formatted_message = _insert_metadata(logger_name, p_message);

    String prefix;

    switch (p_type) {
        case NOTIFY:
            // TODO stub
            // Display some stuff and then fall through into INFO
        case INFO:
            prefix = String("[INFO] ");
            break;
        case DEBUG:
            prefix = String("[DEBUG] ");
            break;
        case TRACE:
            prefix = String("[TRACE] ");
            break;
        case ERROR:
            prefix = String("[ERROR] ");
            break;
        default:
            Array arr;
            arr.append(p_message);
            arr.append(p_type);

            UtilityFunctions::printerr(String("Unexpected log type received:\nMessage: {0}\nType: {1}")
                                           .format(arr));
            break;
    }

    UtilityFunctions::print(prefix, formatted_message);
}

void Logger::notify(const String &p_message, const int p_type) {
    // TODO add notification stuff here

    _log(p_message, NOTIFY);
}

void Logger::info(const String &p_message) {
    _log(p_message, INFO);
}

void Logger::debug(const String &p_message) {
    _log(p_message, DEBUG);
}

void Logger::trace(const String &p_message) {
    _log(p_message, TRACE);
}

void Logger::error(const String &p_message) {
    _log(p_message, ERROR);
}

void Logger::global_log(const String &p_message_id, const String &p_message) {
    UtilityFunctions::print(String("[GLOBAL] "), _insert_metadata(p_message_id, p_message));
}

void Logger::setup(const godot::String &p_name) {
    logger_name = p_name;
}

Logger *Logger::emplace(const godot::String &p_name) {
    Logger *logger = memnew(Logger());
    logger->setup(p_name);

    return logger;
}

void Logger::_bind_methods() {
    ClassDB::bind_method(D_METHOD("notify", "message", "type"), &Logger::notify);
    ClassDB::bind_method(D_METHOD("info", "message"), &Logger::info);
    ClassDB::bind_method(D_METHOD("debug", "message"), &Logger::debug);
    ClassDB::bind_method(D_METHOD("trace", "message"), &Logger::trace);
    ClassDB::bind_method(D_METHOD("error", "message"), &Logger::error);

    ClassDB::bind_method(D_METHOD("setup", "logger_name"), &Logger::setup, DEFVAL(godot::String()));
    ClassDB::bind_static_method(
        "Logger", D_METHOD("emplace", "logger_name"), &Logger::emplace, DEFVAL(godot::String()));
    ClassDB::bind_static_method("Logger", D_METHOD("global_log", "message"), &Logger::global_log);

    BIND_CONSTANT(NOTIFY);
    BIND_CONSTANT(INFO);
    BIND_CONSTANT(DEBUG);
    BIND_CONSTANT(TRACE);
    BIND_CONSTANT(ERROR);

    BIND_ENUM_CONSTANT(TOAST);
    BIND_ENUM_CONSTANT(POPUP);
}
