class_name MicInput
extends PanelContainer

const FEATURE_NAME := "MicInput"

var config: Resource = null
var context: RunnerContext = null

var _logger := Logger.emplace("MicInputGui")

#-----------------------------------------------------------------------------#
# Builtin functions
#-----------------------------------------------------------------------------#

func _ready() -> void:
	var input_device := %InputDevice
	for i in AudioServer.get_input_device_list():
		input_device.add_item(i)
	input_device.item_selected.connect(func(idx: int) -> void:
		AudioServer.input_device = input_device.get_item_text(idx)
	)
	if input_device.get_popup().item_count > 0:
		# TODO pull from config
		input_device.select(0)
	
	var enabled_button := %Enabled
	enabled_button.button_pressed = context.features.has(FEATURE_NAME)
	enabled_button.toggled.connect(func(enabled: bool) -> void:
		if enabled:
			var err := context.add_feature(
				FEATURE_NAME, preload("res://utils/mic_input_listener.gd").new())
			if err != OK:
				if err != ERR_ALREADY_IN_USE:
					return
				_logger.error("Unable to enable mic input")
				
				return
		else:
			var obj: Node = context.remove_feature(FEATURE_NAME)
			obj.queue_free()
	)

#-----------------------------------------------------------------------------#
# Private functions
#-----------------------------------------------------------------------------#

#-----------------------------------------------------------------------------#
# Public functions
#-----------------------------------------------------------------------------#

func save(config) -> void:
	# TODO stub
	pass

func context_needed() -> PackedStringArray:
	return [RunnerContext.Context.CONFIG, RunnerContext.Context.CONTEXT]
