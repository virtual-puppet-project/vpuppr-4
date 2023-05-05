extends Window

# TODO move to a global?
const RunnerType := {
	VRM_RUNNER = "VRM",
	PNG_TUBER_RUNNER = "PNGTuber"
}

const GuiType := {
	STANDARD_GUI = "Standard GUI"
}

var _logger := Logger.emplace("NewRunner")

@onready
var name_input := %NameInput
@onready
var runner_type := %RunnerType
@onready
var gui_type := %GuiType
@onready
var model_path := %ModelPath
@onready
var choose_model := %ChooseModel
@onready
var status := %Status

var runner_data := RunnerData.new()

#-----------------------------------------------------------------------------#
# Builtin functions
#-----------------------------------------------------------------------------#

func _ready() -> void:
	# TODO use default no preview image
	runner_data.preview_path = "C:/Users/theaz/Pictures/astro.png"
	
	var confirm := %Confirm
	confirm.pressed.connect(func() -> void:
		if runner_data.config is VrmConfig:
			pass
		elif runner_data.config is PngTuberConfig:
			runner_data.gui_menus = [
				GuiMenu.new("PNG Tuber", "res://gui/2d/png-tuber-config/png_tuber_config.tscn"),
				GuiMenu.new("Tracking", "res://gui/tracking.tscn"),
				GuiMenu.new("Mic Input", "res://gui/mic_input.tscn")
			]
		
		close_requested.emit(runner_data)
	)
	%Cancel.pressed.connect(func() -> void:
		# TODO this is not great, what to do when the window is closed instead of the cancel button
		close_requested.emit()
	)
	visibility_changed.connect(func() -> void:
		if not visible:
			close_requested.emit()
	)
	close_requested.connect(func(data: RunnerData = null) -> void:
		queue_free()
	)
	
	name_input.text_changed.connect(func(text: String) -> void:
		if text.is_empty():
			confirm.disabled = true
			return
		
		if FileAccess.file_exists("%s.tres" % text):
			confirm.disabled = true
			status.text = "Runner with name %s already exists" % text
			return
		
		# TODO this could be incorrect if the model path is still invalid
		runner_data.name = text
		confirm.disabled = false
	)
	
	var model := %Model
	model_path.text_changed.connect(func(text: String) -> void:
		if text.is_empty():
			confirm.disabled = true
			return
		
		if not FileAccess.file_exists(text):
			confirm.disabled = true
			status.text = "Model does not exist at path %s" % text
			return
		
		# TODO this could be incorrect if the name is still invalid
		runner_data.config.model_path = text
		confirm.disabled = false
	)
	choose_model.pressed.connect(func() -> void:
		var fd := FileDialog.new()
		fd.access = FileDialog.ACCESS_FILESYSTEM
		fd.file_mode = FileDialog.FILE_MODE_OPEN_FILE
		
		fd.file_selected.connect(func(path: String) -> void:
			fd.close_requested.emit(path)
		)
		fd.visibility_changed.connect(func() -> void:
			if not fd.visible:
				fd.close_requested.emit()
		)
		fd.close_requested.connect(func() -> void:
			fd.queue_free()
		)
		
		add_child(fd)
		fd.popup_centered_ratio()
		
		var path: Variant = await fd.close_requested
		
		if path == null or not path is String:
			return
		
		model_path.text = path
		model_path.text_changed(model_path.text)
	)
	
	var runner_type_popup: PopupMenu = runner_type.get_popup()
	for i in RunnerType.values():
		runner_type_popup.add_item(i)
	runner_type_popup.index_pressed.connect(func(idx: int) -> void:
		match runner_type_popup.get_item_text(idx):
			RunnerType.VRM_RUNNER:
				runner_data.config = VrmConfig.new()
				runner_data.runner_path = "res://screens/runners/vrm_runner.tscn"
				model.show()
			RunnerType.PNG_TUBER_RUNNER:
				runner_data.config = PngTuberConfig.new()
				runner_data.runner_path = "res://screens/runners/png_tuber_runner.tscn"
				model.hide()
			_:
				_logger.error("Unhandled gui type: %s" % runner_type_popup.get_item_text(idx))
	)
	
	var gui_type_popup: PopupMenu = gui_type.get_popup()
	for i in GuiType.values():
		gui_type_popup.add_item(i)
	gui_type_popup.index_pressed.connect(func(idx: int) -> void:
		match gui_type_popup.get_item_text(idx):
			GuiType.STANDARD_GUI:
				runner_data.gui_path = "res://gui/standard_gui.tscn"
			_:
				_logger.error("Unhandled gui type: %s" % gui_type_popup.get_item_text(idx))
	)

#-----------------------------------------------------------------------------#
# Private functions
#-----------------------------------------------------------------------------#

#-----------------------------------------------------------------------------#
# Public functions
#-----------------------------------------------------------------------------#

