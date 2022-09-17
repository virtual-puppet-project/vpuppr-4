extends CanvasLayer

var viewport: Viewport
var screen_center := Vector2.ZERO
var max_parallax_offset := Vector2.ZERO

var background: TextureRect
var foreground: TextureRect



#-----------------------------------------------------------------------------#
# Builtin functions                                                           #
#-----------------------------------------------------------------------------#

func _ready() -> void:
	while not get_tree().root.has_node("AM"):
		await get_tree().process_frame
	
	var current_screen_size := DisplayServer.screen_get_size(
		DisplayServer.window_get_current_screen())
	var new_window_size := current_screen_size * 0.75
	
	DisplayServer.window_set_size(new_window_size)
	DisplayServer.window_set_position((current_screen_size * 0.5) - (new_window_size * 0.5))
	
	var res = Result.err(ERR_BUG, "asdf");
	print(res.unwrap_err());

#-----------------------------------------------------------------------------#
# Connections                                                                 #
#-----------------------------------------------------------------------------#

#-----------------------------------------------------------------------------#
# Private functions                                                           #
#-----------------------------------------------------------------------------#

#-----------------------------------------------------------------------------#
# Public functions                                                            #
#-----------------------------------------------------------------------------#

