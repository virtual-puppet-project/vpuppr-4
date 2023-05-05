class_name PngTuberConfig
extends Resource

const DEFAULT_IMAGE_PATH := "res://assets/VpupprDuck.png"

@export
var forward := PngTuberFaceState.new()
@export
var left := PngTuberFaceState.new()
@export
var right := PngTuberFaceState.new()
@export
var up := PngTuberFaceState.new()
@export
var down := PngTuberFaceState.new()

@export
var feature_configs: Array[Resource] = []
