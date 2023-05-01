extends Window

signal confirmed(data: RunnerData)

#-----------------------------------------------------------------------------#
# Builtin functions
#-----------------------------------------------------------------------------#

func _ready() -> void:
	var name_input := %Name
	name_input.text_changed.connect(func(text: String) -> void:
		pass
	)
	
	var runner_type: OptionButton = %RunnerType
	var runner_type_popup := runner_type.get_popup()
	
	var gui_type: OptionButton = %GuiType
	var gui_type_popup := gui_type.get_popup()
	
	%ModelPath.text_changed.connect(func(text: String) -> void:
		pass
	)
	var choose_model := %ChooseModel
	choose_model.pressed.connect(func() -> void:
#		var popup := FileDialog.new()
#		popup.current_dir = "" # TODO pull from config
#		popup.add_filter("*.glb", "GLB models")
#		popup.add_filter("*.vrm", "VRM models")
#		# TODO pull more supported formats from config?
#		popup.access = FileDialog.ACCESS_FILESYSTEM
#		popup.file_mode = FileDialog.FILE_MODE_OPEN_FILE
#
#		add_child(popup)
#		popup.popup_centered_ratio(0.5)
#
#		var file_dialog_hide := handle_popup_hide.bind(popup)
#		popup.visibility_changed.connect(file_dialog_hide)
#		popup.close_requested.connect(file_dialog_hide)
#
#		popup.file_selected.connect(func(path: String) -> void:
#			_logger.debug(path)
#		)
		pass
	)
	%Confirm.pressed.connect(func() -> void:
		var runner_data := RunnerData.new()
		runner_data.name = name_input.text
		# TODO select runner and config based off of runner
#		runner_data.runner_path = "res://screens/runners/png_tuber_runner.tscn"
#		runner_data.gui_path = "res://gui/standard_gui.tscn"
#		runner_data.config = PngTuberConfig.new()
#		runner_data.model_path = "res://assets/VpupprDuck.png"

		# TODO use default no preview image
		runner_data.preview_path = "C:/Users/theaz/Pictures/astro.png"
		
		# TODO change this based off of the runner that's selected
#		runner_data.gui_menus = [
#			GuiMenu.new("PNG Tuber", "res://gui/2d/png-tuber-config/png_tuber_config.tscn"),
#			GuiMenu.new("Tracking", "res://gui/tracking.tscn"),
#			GuiMenu.new("Mic Input", "res://gui/mic_input.tscn")
#		]
		
		confirmed.emit(runner_data)
	)
	%Cancel.pressed.connect(func() -> void:
		# TODO this is not great, what to do when the window is closed instead of the cancel button
		confirmed.emit(null)
		queue_free()
	)

#-----------------------------------------------------------------------------#
# Private functions
#-----------------------------------------------------------------------------#

#-----------------------------------------------------------------------------#
# Public functions
#-----------------------------------------------------------------------------#

