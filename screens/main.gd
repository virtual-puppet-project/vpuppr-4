extends CanvasLayer

## The entrypoint to vpuppr. Allows for initialization of everything.
##
## DO NOT LOAD ANY USER DATA HERE.

#-----------------------------------------------------------------------------#
# Builtin functions
#-----------------------------------------------------------------------------#

func _init() -> void:
	var current_screen_size := DisplayServer.screen_get_size(
		DisplayServer.window_get_current_screen())
	var new_window_size := current_screen_size * 0.75
	
	DisplayServer.window_set_size(new_window_size)
	DisplayServer.window_set_position((current_screen_size * 0.5) - (new_window_size * 0.5))

func _ready() -> void:
	get_tree().change_scene_to_file("res://screens/runner_selection.tscn")

#-----------------------------------------------------------------------------#
# Private functions
#-----------------------------------------------------------------------------#

#-----------------------------------------------------------------------------#
# Public functions
#-----------------------------------------------------------------------------#

