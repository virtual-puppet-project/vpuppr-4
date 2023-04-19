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
	# TODO for whatever reason, godot tries to move it to screen 1??? So force it to 0
	DisplayServer.window_set_current_screen(0)

func _ready() -> void:
	# We only need to cache this to avoid stuttering when loading a runner GUI for the first time
	# Thus, we don't actually check to see if we actually loaded anything
	if ResourceLoader.load_threaded_request("res://assets/main.theme", "Theme", true) != OK:
		printerr("Unable to cache main gui theme")
	
	get_tree().change_scene_to_file("res://screens/runner_selection.tscn")

#-----------------------------------------------------------------------------#
# Private functions
#-----------------------------------------------------------------------------#

#-----------------------------------------------------------------------------#
# Public functions
#-----------------------------------------------------------------------------#

