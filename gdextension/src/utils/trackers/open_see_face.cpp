#include "open_see_face.h"

float OpenSeeFaceData::get_time() {
    return time;
}

int OpenSeeFaceData::get_id() {
    return id;
}

Vector2i OpenSeeFaceData::get_camera_resolution() {
    return camera_resolution;
}

float OpenSeeFaceData::get_right_eye_open() {
    return right_eye_open;
}

float OpenSeeFaceData::get_left_eye_open() {
    return left_eye_open;
}

Quaternion OpenSeeFaceData::get_right_gaze() {
    return right_gaze;
}

Quaternion OpenSeeFaceData::get_left_gaze() {
    return left_gaze;
}

bool OpenSeeFaceData::get_got_3d_points() {
    return got_3d_points;
}

float OpenSeeFaceData::get_fit_3d_error() {
    return fit_3d_error;
}

Vector3 OpenSeeFaceData::get_rotation() {
    return rotation;
}

Vector3 OpenSeeFaceData::get_translation() {
    return translation;
}

Quaternion OpenSeeFaceData::get_raw_quaternion() {
    return raw_quaternion;
}

Vector3 OpenSeeFaceData::get_raw_euler() {
    return raw_euler;
}

PackedFloat32Array OpenSeeFaceData::get_confidence() {
    return confidence;
}

PackedVector2Array OpenSeeFaceData::get_points() {
    return points;
}

PackedVector3Array OpenSeeFaceData::get_points_3d() {
    return points_3d;
}

float OpenSeeFaceData::get_eye_left() {
    return eye_left;
}

float OpenSeeFaceData::get_eye_right() {
    return eye_right;
}

float OpenSeeFaceData::get_eyebrow_steepness_left() {
    return eyebrow_steepness_left;
}

float OpenSeeFaceData::get_eyebrow_up_down_left() {
    return eyebrow_up_down_left;
}

float OpenSeeFaceData::get_eyebrow_quirk_left() {
    return eyebrow_quirk_left;
}

float OpenSeeFaceData::get_eyebrow_steepness_right() {
    return eyebrow_steepness_right;
}

float OpenSeeFaceData::get_eyebrow_up_down_right() {
    return eyebrow_up_down_right;
}

float OpenSeeFaceData::get_eyebrow_quirk_right() {
    return eyebrow_quirk_right;
}

float OpenSeeFaceData::get_mouth_corner_up_down_left() {
    return mouth_corner_up_down_left;
}

float OpenSeeFaceData::get_mouth_corner_in_out_left() {
    return mouth_corner_in_out_left;
}

float OpenSeeFaceData::get_mouth_corner_up_down_right() {
    return mouth_corner_up_down_right;
}

float OpenSeeFaceData::get_mouth_corner_in_out_right() {
    return mouth_corner_in_out_right;
}

float OpenSeeFaceData::get_mouth_open() {
    return mouth_open;
}

float OpenSeeFaceData::get_mouth_wide() {
    return mouth_wide;
}

OpenSeeFaceData::OpenSeeFaceData() {
    time = 0.0;
    id = 0;

    camera_resolution = Vector2i();

    right_eye_open = 0.0;
    left_eye_open = 0.0;

    right_gaze = Quaternion();
    left_gaze = Quaternion();

    got_3d_points = false;
    fit_3d_error = 0.0;

    rotation = Vector3();
    translation = Vector3();

    raw_quaternion = Quaternion();
    raw_euler = Vector3();

    confidence = PackedFloat32Array();
    points = PackedVector2Array();
    points_3d = PackedVector3Array();
}

OpenSeeFaceData::~OpenSeeFaceData() {}

void OpenSeeFaceData::_bind_methods() {
    ClassDB::bind_method(D_METHOD("get_time"), &OpenSeeFaceData::get_time);
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "time"), "", "get_time");

    ClassDB::bind_method(D_METHOD("get_id"), &OpenSeeFaceData::get_id);
    ADD_PROPERTY(PropertyInfo(Variant::INT, "id"), "", "get_id");

    ClassDB::bind_method(D_METHOD("get_camera_resolution"), &OpenSeeFaceData::get_camera_resolution);
    ADD_PROPERTY(PropertyInfo(Variant::VECTOR2I, "camera_resolution"), "", "get_camera_resolution");

    ClassDB::bind_method(D_METHOD("get_right_eye_open"), &OpenSeeFaceData::get_right_eye_open);
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "right_eye_open"), "", "get_right_eye_open");

    ClassDB::bind_method(D_METHOD("get_left_eye_open"), &OpenSeeFaceData::get_left_eye_open);
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "left_eye_open"), "", "get_left_eye_open");

    // TODO add the rest of the properties
}

Error OpenSeeFace::start(const Variant **p_args, GDExtensionInt p_arg_count, GDExtensionCallError &p_error) {
    //

    return OK;
}

Error OpenSeeFace::stop(const Variant **p_args, GDExtensionInt p_arg_count, GDExtensionCallError &p_error) {
    //

    return OK;
}

void OpenSeeFace::_bind_methods() {
    {
        MethodInfo mi;
        mi.name = "start";
        ClassDB::bind_vararg_method(METHOD_FLAG_VARARG, "start", &OpenSeeFace::start, mi);
    }

    {
        MethodInfo mi;
        mi.name = "stop";
        ClassDB::bind_vararg_method(METHOD_FLAG_VARARG, "stop", &OpenSeeFace::stop, mi);
    }
}
