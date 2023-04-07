#ifndef MEOW_FACE_H
#define MEOW_FACE_H

#include <godot_cpp/classes/json.hpp>
#include <godot_cpp/classes/packet_peer_udp.hpp>
#include <godot_cpp/classes/thread.hpp>
#include <godot_cpp/core/binder_common.hpp>

#include "abstract_tracker.h"

class MeowFaceData : public RefCounted {
    GDCLASS(MeowFaceData, RefCounted);

    Dictionary blend_shapes;

    Vector3 head_rotation;
    Vector3 head_position;

    Vector3 left_eye_rotation;
    Vector3 right_eye_rotation;

   private:
    void set_blend_shape(const String &p_name, const float &p_value);
    void set_head_rotation(const Dictionary &p_data);
    void set_head_position(const Dictionary &p_data);
    void set_left_eye_rotation(const Dictionary &p_data);
    void set_right_eye_rotation(const Dictionary &p_data);

    _FORCE_INLINE_ Dictionary _default_xyz() const {
        Dictionary d = Dictionary();
        d["x"] = 0.0;
        d["y"] = 0.0;
        d["z"] = 0.0;

        return d;
    }

   protected:
    static void _bind_methods();

   public:
    Dictionary get_blend_shapes();
    Vector3 get_head_rotation();
    Vector3 get_head_position();
    Vector3 get_left_eye_rotation();
    Vector3 get_right_eye_rotation();

    void parse(const Dictionary &p_data);

    MeowFaceData();
    ~MeowFaceData();
};

class MeowFace : public AbstractTracker {
    GDCLASS(MeowFace, AbstractTracker);

    Ref<PacketPeerUDP> client;
    Ref<Thread> receive_thread;
    int server_poll_interval;
    bool stop_reception;

    _FORCE_INLINE_ PackedByteArray _id_packet() {
        Dictionary d;
        d["messageType"] = "iOSTrackingDataRequest";
        d["time"] = 1.0;
        d["sentBy"] = "vpuppr";
        Array arr;
        arr.push_back(21412);
        d["ports"] = arr;

        return JSON::stringify(d).to_utf8_buffer();
    }

   private:
    Error _receive();

   protected:
    static void _bind_methods();

   public:
    virtual Error start(const Variant **p_args, GDExtensionInt p_arg_count, GDExtensionCallError &p_error) override;
    virtual Error stop() override;

    static StringName identifier();

    MeowFace();
    ~MeowFace();
};

#endif  // MEOW_FACE_H
