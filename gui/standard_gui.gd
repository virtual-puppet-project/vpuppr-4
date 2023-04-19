extends CanvasLayer

var _menu_items := VBoxContainer.new()
## Button name to popup instance.
var _active_popups := {}

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
	
	$VBoxContainer/HSplitContainer.split_offset = DisplayServer.window_get_size(
		DisplayServer.window_get_current_screen()).x * 0.15
	
	_menu_items.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	%MenuParent.add_child(_menu_items)

#-----------------------------------------------------------------------------#
# Private functions
#-----------------------------------------------------------------------------#

func _popup(button_name: String, ui: PackedScene) -> void:
	if _active_popups.has(button_name):
		_active_popups[button_name].move_to_foreground()
		return
	
	var instance = ui.instantiate()
	
	var window := Window.new()
	window.add_child(instance)
	window.title = instance.name
	
	window.close_requested.connect(func() -> void:
		_active_popups.erase(button_name)
		window.queue_free()
	)
	
	_active_popups[button_name] = window
	
	get_tree().root.add_child(window)
	window.popup_centered_ratio(0.5)

#-----------------------------------------------------------------------------#
# Public functions
#-----------------------------------------------------------------------------#

func add_menu(button_name: String, button_resource_path: String) -> void:
	var button := Button.new()
	button.name = button_name
	button.text = button_name
	button.focus_mode = Control.FOCUS_NONE
	button.pressed.connect(func() -> void:
		_popup(button_name, load(button_resource_path))
	)
	
	_menu_items.add_child(button)
