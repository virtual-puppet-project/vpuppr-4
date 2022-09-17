#ifndef LOGGER_H
#define LOGGER_H

#include <godot_cpp/classes/ref_counted.hpp>
#include <godot_cpp/core/binder_common.hpp>

using namespace godot;

class Logger : public RefCounted {
    GDCLASS(Logger, RefCounted);

    godot::String logger_name;

   private:
    void _log(const String &p_message, const int p_type);

   protected:
    static void _bind_methods();

   public:
    enum {
        NOTIFY,
        INFO,
        DEBUG,
        TRACE,
        ERROR
    };

    enum NotifyType {
        TOAST,
        POPUP
    };

    void setup(const String &p_name = String());
    static Logger *emplace(const String &p_name = String());

    void notify(const String &p_message, const int p_type);
    void info(const String &p_message);
    void debug(const String &p_message);
    void trace(const String &p_message);
    void error(const String &p_message);

    Logger() {}
    ~Logger() {}
};

VARIANT_ENUM_CAST(Logger, NotifyType);

#endif  // LOGGER_H
