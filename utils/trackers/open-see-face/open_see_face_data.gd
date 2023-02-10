class_name OpenSeeFaceData
extends RefCounted

## Number of facial points recognized by the tracker.
const NUMBER_OF_POINTS: int = 68

## ID of the tracked face.
var time: float = -1.0
var id: int = -1
## The camera resolution.
var camera_resolution := Vector2i.ZERO
var right_eye_open: float = -1.0
var left_eye_open: float = 01.0
var right_gaze := Quaternion.IDENTITY
var left_gaze := Quaternion.IDENTITY
var got_3d_points := false
var fit_3d_error := false
var rotation := Vector3.ZERO
var translation := Vector3.ZERO
var raw_quaternion := Quaternion.IDENTITY
var raw_euler := Vector3.ZERO
var confidence := PackedFloat32Array()
var points := PackedVector2Array()
var points_3d := PackedVector3Array()

var eye_left: float = 0.0
var eye_right: float = 0.0

var eyebrow_steepness_left: float = 0.0
var eyebrow_up_down_left: float = 0.0
var eyebrow_quirk_left: float = 0.0

var eyebrow_steepness_right: float = 0.0
var eyebrow_up_down_right: float = 0.0
var eyebrow_quirk_right: float = 0.0

var mouth_corner_up_down_left: float = 0.0
var mouth_corner_in_out_left: float = 0.0

var mouth_corner_up_down_right: float = 0.0
var mouth_corner_in_out_right: float = 0.0

var mouth_open: float = 0.0
var mouth_wide: float = 0.0

#-----------------------------------------------------------------------------#
# Builtin functions
#-----------------------------------------------------------------------------#

func _init(buffer: PackedByteArray) -> void:
	var spb := StreamPeerBuffer.new()
	spb.data_array = buffer
	
	time = spb.get_double()
	id = spb.get_32()
	camera_resolution = _read_vector2(spb)
	right_eye_open = spb.get_float()
	left_eye_open = spb.get_float()
	got_3d_points = true if spb.get_8() != 0 else false
	fit_3d_error = spb.get_float()
	raw_quaternion = _read_quaternion(spb)
	raw_euler = _read_vector3(spb)
	rotation = raw_euler
	rotation.x = rotation.x if rotation.x > 0.0 else rotation.x + 360
	
	var x := spb.get_float()
	var y := spb.get_float()
	var z := spb.get_float()
	translation = -Vector3(y, x, z)
	
	for point_idx in NUMBER_OF_POINTS:
		confidence.set(point_idx, spb.get_float())
	for point_idx in NUMBER_OF_POINTS:
		points.set(point_idx, _read_vector2(spb))
	for point_idx in NUMBER_OF_POINTS + 2:
		points_3d.set(point_idx, _read_vector3(spb))
	
	# TODO this calculation is kind of wrong
	right_gaze = Quaternion(Transform3D().looking_at(points_3d[66] - points_3d[68], Vector3.UP).basis).normalized()
	left_gaze = Quaternion(Transform3D().looking_at(points_3d[67] - points_3d[69], Vector3.UP).basis).normalized()
	
	eye_left = spb.get_float()
	eye_right = spb.get_float()
	eyebrow_steepness_left = spb.get_float()
	eyebrow_up_down_left = spb.get_float()
	eyebrow_quirk_left = spb.get_float()
	eyebrow_steepness_right = spb.get_float()
	eyebrow_up_down_right = spb.get_float()
	eyebrow_quirk_right = spb.get_float()
	mouth_corner_up_down_left = spb.get_float()
	mouth_corner_in_out_left = spb.get_float()
	mouth_corner_up_down_right = spb.get_float()
	mouth_corner_in_out_right = spb.get_float()
	mouth_open = spb.get_float()
	mouth_wide = spb.get_float()

#-----------------------------------------------------------------------------#
# Private functions
#-----------------------------------------------------------------------------#

func _read_vector2(b: StreamPeerBuffer) -> Vector2:
	return Vector2(b.get_float(), b.get_float())

func _read_vector3(b: StreamPeerBuffer) -> Vector3:
	return Vector3(b.get_float(), b.get_float(), b.get_float())

func _read_quaternion(b: StreamPeerBuffer) -> Quaternion:
	return Quaternion(b.get_float(), b.get_float(), b.get_float(), b.get_float())

#-----------------------------------------------------------------------------#
# Public functions
#-----------------------------------------------------------------------------#
