class_name RunnerData
extends Resource

@export
var name := ""
@export
var runner_path := ""
@export
var gui_path := ""
# TODO change to typed array once those are stabilized
@export
var gui_menus := []
@export
var model_path := ""
@export
var preview_path := ""
@export
var favorite := false
@export
var last_used := Datetime.new()

#-----------------------------------------------------------------------------#
# Builtin functions
#-----------------------------------------------------------------------------#

func _to_string() -> String:
	return JSON.stringify({
		"name": name,
		"runner_path": runner_path,
		"gui_path": gui_path,
		"model_path": model_path,
		"favorite": favorite,
		"last_used": last_used
	}, "\t")

#-----------------------------------------------------------------------------#
# Private functions
#-----------------------------------------------------------------------------#

#-----------------------------------------------------------------------------#
# Public functions
#-----------------------------------------------------------------------------#

