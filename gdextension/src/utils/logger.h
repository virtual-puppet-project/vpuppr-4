#ifndef LOGGER_H
#define LOGGER_H

#include <godot_cpp/classes/ref_counted.hpp>
#include <godot_cpp/core/binder_common.hpp>

using namespace godot;

class Logger : public RefCounted {
    GDCLASS(Logger, RefCounted);

    String logger_name;

   private:
    void _log(const String &p_message, const int p_type);
    static void _add_to_log_store(const String &p_message);
    // Needs to be static since this is also accessible from global_log
    static String _insert_metadata(const String &p_message_id, const String &p_message);

   protected:
    static void _bind_methods();

   public:
    enum {
        NOTIFY,
        INFO,
        WARN,
        DEBUG,
        TRACE,
        ERROR
    };

    enum NotifyType {
        TOAST,
        POPUP
    };

    // Logger *name(const String &p_name);

    void notify(const String &p_message, const int p_type);
    void info(const String &p_message);
    void warn(const String &p_message);
    void debug(const String &p_message);
    void trace(const String &p_message);
    void error(const String &p_message);

    static Ref<Logger> emplace(const String &p_logger_name);
    static void global(const String &p_message_id, const String &p_message);

    static void set_log_store_max(const int p_max);
    static TypedArray<String> get_logs();

    Logger() {}
    ~Logger() {}
};

VARIANT_ENUM_CAST(Logger, NotifyType);

#endif  // LOGGER_H
