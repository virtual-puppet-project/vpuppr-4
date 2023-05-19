class_name RunnerData
extends Resource

## The type of config the runner data will use.
enum ConfigType {
	NONE, ## This indicates a corrupted config.
	VRM, ## VRM and GLB models.
	PNG, ## PngTuber models.
	CUSTOM, ## Other, needs to be handled elsewhere.
}

@export
var name := ""
@export
var runner_path := ""
@export
var gui_path := ""
@export
var config: Resource = null
@export
var config_type := ConfigType.NONE
# TODO change to typed array once those are stabilized
@export
var gui_menus := []
# TODO use reasonable default
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
		"favorite": favorite,
		"last_used": last_used
	}, "\t")

#-----------------------------------------------------------------------------#
# Private functions
#-----------------------------------------------------------------------------#

#-----------------------------------------------------------------------------#
# Public functions
#-----------------------------------------------------------------------------#

