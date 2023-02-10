#ifndef LOGGER_H
#define LOGGER_H

#include <godot_cpp/classes/ref_counted.hpp>
#include <godot_cpp/core/binder_common.hpp>

using namespace godot;

class Logger : public RefCounted {
    GDCLASS(Logger, RefCounted);

    String logger_name;

   private:
    void _log(const Variant **p_args, GDExtensionInt p_arg_count, const int p_type);
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

    void notify(const Variant **p_args, GDExtensionInt p_arg_count, GDExtensionCallError &p_error);
    void info(const Variant **p_args, GDExtensionInt p_arg_count, GDExtensionCallError &p_error);
    void warn(const Variant **p_args, GDExtensionInt p_arg_count, GDExtensionCallError &p_error);
    void debug(const Variant **p_args, GDExtensionInt p_arg_count, GDExtensionCallError &p_error);
    void trace(const Variant **p_args, GDExtensionInt p_arg_count, GDExtensionCallError &p_error);
    void error(const Variant **p_args, GDExtensionInt p_arg_count, GDExtensionCallError &p_error);

    static Ref<Logger> emplace(const String &p_logger_name);
    static void global(const String &p_message_id, const String &p_message);

    static void set_log_store_max(const int p_max);
    static TypedArray<String> get_logs();

    Logger() {}
    ~Logger() {}
};

VARIANT_ENUM_CAST(Logger::NotifyType);

#endif  // LOGGER_H
