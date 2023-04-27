extends CanvasLayer

## Sentinel for setting up top bar menu buttons.
const SEPARATOR := ""
const AppOptions := {
	MAIN_MENU = "Main Menu",
	SETTINGS = "Settings",
	LOGS = "Logs",
	QUIT = "Quit"
}
const DebugOptions := {
	DEBUG_CONSOLE = "Debug Console"
}
const HelpOptions := {
	IN_APP_HELP = "In-app Help",
	ABOUT = "About",
	GITHUB = "GitHub",
	DISCORD = "Discord",
	LICENSES = "Licenses"
}

var context: RunnerHandler = null

var _menu_items := VBoxContainer.new()
## Button name to popup instance.
var _active_popups := {}

#-----------------------------------------------------------------------------#
# Builtin functions
#-----------------------------------------------------------------------------#

func _ready() -> void:
	var setup_popups := func(popup: PopupMenu, items: PackedStringArray, callback: Callable) -> void:
		for i in items:
			if not i.is_empty():
				popup.add_item(i)
			else:
				popup.add_separator()
		
		popup.index_pressed.connect(callback)
	
	var popup: PopupMenu = %App.get_popup()
	setup_popups.call(
		popup,
		[
			AppOptions.MAIN_MENU,
			SEPARATOR,
			AppOptions.SETTINGS,
			AppOptions.LOGS,
			SEPARATOR,
			AppOptions.QUIT
		],
		func(idx: int) -> void:
			match popup.get_item_text(idx):
				AppOptions.MAIN_MENU:
					# TODO add way to skip fade in transition
					get_tree().change_scene_to_file("res://screens/runner-selection/runner_selection.tscn")
				AppOptions.SETTINGS:
					pass
				AppOptions.LOGS:
					pass
				AppOptions.QUIT:
					get_tree().quit()
	)
	
	popup = %Debug.get_popup()
	setup_popups.call(
		popup,
		[
			DebugOptions.DEBUG_CONSOLE
		],
		func(idx: int) -> void:
			match popup.get_item_text(idx):
				DebugOptions.DEBUG_CONSOLE:
					pass
	)
	
	popup = %Help.get_popup()
	setup_popups.call(
		popup,
		[
			HelpOptions.IN_APP_HELP,
			HelpOptions.ABOUT,
			SEPARATOR,
			HelpOptions.GITHUB,
			HelpOptions.DISCORD,
			SEPARATOR,
			HelpOptions.LICENSES
		],
		func(idx: int) -> void:
			match popup.get_item_text(idx):
				HelpOptions.IN_APP_HELP:
					pass
				HelpOptions.ABOUT:
					pass
				HelpOptions.GITHUB:
					pass
				HelpOptions.DISCORD:
					pass
				HelpOptions.LICENSES:
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
