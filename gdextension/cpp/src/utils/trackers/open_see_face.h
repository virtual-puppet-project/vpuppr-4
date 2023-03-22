#ifndef OPEN_SEE_FACE_H
#define OPEN_SEE_FACE_H

#include <godot_cpp/classes/node.hpp>
#include <godot_cpp/classes/packet_peer_udp.hpp>
#include <godot_cpp/classes/ref_counted.hpp>
#include <godot_cpp/classes/stream_peer_buffer.hpp>
#include <godot_cpp/classes/thread.hpp>
#include <godot_cpp/classes/udp_server.hpp>
#include <godot_cpp/core/binder_common.hpp>

#include "abstract_tracker.h"

using namespace godot;

/// @brief Tracking data from an OpenSeeFace packet.
class OpenSeeFaceData : public RefCounted {
    GDCLASS(OpenSeeFaceData, RefCounted);

    const int NUMBER_OF_POINTS = 68;

   protected:
    static void _bind_methods();

    float time;
    int id;

    Vector2i camera_resolution;

    float right_eye_open;
    float left_eye_open;

    Quaternion right_gaze;
    Quaternion left_gaze;

    bool got_3d_points;
    float fit_3d_error;

    Vector3 rotation;
    Vector3 translation;

    Quaternion raw_quaternion;
    Vector3 raw_euler;

    PackedFloat32Array confidence;
    PackedVector2Array points;
    PackedVector3Array points_3d;

    float eye_left;
    float eye_right;

    float eyebrow_steepness_left;
    float eyebrow_up_down_left;
    float eyebrow_quirk_left;

    float eyebrow_steepness_right;
    float eyebrow_up_down_right;
    float eyebrow_quirk_right;

    float mouth_corner_up_down_left;
    float mouth_corner_in_out_left;

    float mouth_corner_up_down_right;
    float mouth_corner_in_out_right;

    float mouth_open;
    float mouth_wide;

    /// @brief Helper function for constructing Vector2s from a buffer.
    /// @param b The buffer to read from.
    /// @return A Vector2.
    inline Vector2 _read_vector2(Ref<StreamPeerBuffer> &b) {
        return Vector2(b->get_float(), b->get_float());
    }

    /// @brief Helper function for constructing Vector3s from a buffer.
    /// @param b The buffer to read from.
    /// @return A Vector3.
    inline Vector3 _read_vector3(Ref<StreamPeerBuffer> &b) {
        return Vector3(b->get_float(), b->get_float(), b->get_float());
    }

    /// @brief Helper function for constructing Quaternions from a buffer.
    /// @param b The buffer to read from.
    /// @return A Quaternion.
    inline Quaternion _read_quaternion(Ref<StreamPeerBuffer> &b) {
        return Quaternion(b->get_float(), b->get_float(), b->get_float(), b->get_float());
    }

   public:
    float get_time();
    int get_id();

    Vector2i get_camera_resolution();

    float get_right_eye_open();
    float get_left_eye_open();

    Quaternion get_right_gaze();
    Quaternion get_left_gaze();

    bool get_got_3d_points();
    float get_fit_3d_error();

    Vector3 get_rotation();
    Vector3 get_translation();

    Quaternion get_raw_quaternion();
    Vector3 get_raw_euler();

    PackedFloat32Array get_confidence();
    PackedVector2Array get_points();
    PackedVector3Array get_points_3d();

    float get_eye_left();
    float get_eye_right();

    float get_eyebrow_steepness_left();
    float get_eyebrow_up_down_left();
    float get_eyebrow_quirk_left();

    float get_eyebrow_steepness_right();
    float get_eyebrow_up_down_right();
    float get_eyebrow_quirk_right();

    float get_mouth_corner_up_down_left();
    float get_mouth_corner_in_out_left();

    float get_mouth_corner_up_down_right();
    float get_mouth_corner_in_out_right();

    float get_mouth_open();
    float get_mouth_wide();

    /// @brief Takes a buffer and parses it.
    /// @param b The buffer to parse.
    void read_packet(const PackedByteArray &b);

    OpenSeeFaceData();
    ~OpenSeeFaceData();
};

class OpenSeeFace : public AbstractTracker {
    GDCLASS(OpenSeeFace, AbstractTracker);

    /// @brief The size of a packet from OpenSeeFace.
    const int PACKET_FRAME_SIZE = 8 + 4 + 2 * 4 + 2 * 4 + 1 + 4 + 3 * 4 + 3 * 4 + 4 * 4 + 4 * 68 + 4 * 2 * 68 + 4 * 3 * 70 + 4 * 14;
    /// @brief The maximum allowed FPS. Anything higher than this is unreasonable.
    const double MAX_TRACKER_FPS = 144.0;

    const double SERVER_POLL_INTERVAL = 1.0 / MAX_TRACKER_FPS;

    const float MAX_FIT_3D_ERROR = 100.0;

    Ref<UDPServer> server;
    Ref<PacketPeerUDP> connection;
    Ref<Thread> receive_thread;
    int receive_pid;
    bool stop_reception;
    bool should_poll;
    double poll_counter;

    /// @brief Function to run in thread.
    /// @return The error code.
    Error _receive();

   protected:
    static void _bind_methods();

   public:
    virtual Error start(const Variant **p_args, GDExtensionInt p_arg_count, GDExtensionCallError &p_error) override;
    virtual Error stop() override;

    void _process(double delta) override;

    OpenSeeFace();
    ~OpenSeeFace();
};

#endif  // OPEN_SEE_FACE_H
