class_name PngTuberConfig
extends Resource

enum States {
	NONE,
	DEFAULT,
	LEFT,
	RIGHT,
	UP,
	DOWN,
	CUSTOM
}

class FaceState extends Resource:
	@export
	var state := States.NONE
	
	@export
	var default := ""
	@export
	var mouth_open := ""
	@export
	var blink := ""
	@export
	var joy := ""
	@export
	var angry := ""
	@export
	var sorrow := ""
	@export
	var fun := ""

@export
var forward := FaceState.new()
@export
var left := FaceState.new()
@export
var right := FaceState.new()
@export
var up := FaceState.new()
@export
var down := FaceState.new()

@export
var feature_configs: Array[Resource] = []

#-----------------------------------------------------------------------------#
# Builtin functions
#-----------------------------------------------------------------------------#

func _init() -> void:
	pass

#-----------------------------------------------------------------------------#
# Private functions
#-----------------------------------------------------------------------------#

#-----------------------------------------------------------------------------#
# Public functions
#-----------------------------------------------------------------------------#

