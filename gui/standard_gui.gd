extends CanvasLayer

@onready
var _menu_items := %MenuItems

var _grabber_grabbed := false

#-----------------------------------------------------------------------------#
# Builtin functions
#-----------------------------------------------------------------------------#

func _ready() -> void:
	%App.pressed.connect(func() -> void:
		pass
	)
	%Debug.pressed.connect(func() -> void:
		pass
	)
	%Help.pressed.connect(func() -> void:
		pass
	)
	
	# TODO testing
	var tracking_button := Button.new()
	tracking_button.name = "Tracking"
	tracking_button.text = "Tracking"
	tracking_button.pressed.connect(func() -> void:
		_popup(preload("res://gui/tracking.tscn"))
	)
	_menu_items.add_child(tracking_button)

#-----------------------------------------------------------------------------#
# Private functions
#-----------------------------------------------------------------------------#

func _popup(ui: PackedScene) -> void:
	var instance = ui.instantiate()
	
	var window := Window.new()
#	window.current_screen = get_tree().root.current_screen
	window.add_child(instance)
	window.title = instance.name
	
	window.close_requested.connect(func() -> void:
		window.queue_free()
	)
	
	get_tree().root.add_child(window)
	window.popup_centered()

#-----------------------------------------------------------------------------#
# Public functions
#-----------------------------------------------------------------------------#

