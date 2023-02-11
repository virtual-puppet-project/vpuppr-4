#ifndef OPEN_SEE_FACE_H
#define OPEN_SEE_FACE_H

#include <godot_cpp/classes/node.hpp>
#include <godot_cpp/classes/ref_counted.hpp>
#include <godot_cpp/core/binder_common.hpp>

#include "abstract_tracker.h"

using namespace godot;

class OpenSeeFaceData : public RefCounted {
    GDCLASS(OpenSeeFaceData, RefCounted);

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

    OpenSeeFaceData();
    ~OpenSeeFaceData();
};

class OpenSeeFace : public AbstractTracker {
    GDCLASS(OpenSeeFace, AbstractTracker);

   protected:
    static void _bind_methods();

   public:
    virtual Error start(const Variant **p_args, GDExtensionInt p_arg_count, GDExtensionCallError &p_error) override;
    virtual Error stop(const Variant **p_args, GDExtensionInt p_arg_count, GDExtensionCallError &p_error) override;
};

#endif  // OPEN_SEE_FACE_H
