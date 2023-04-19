class_name PngTuberRunner
extends Node2D

const DIM_COLOR := Color(1.0, 1.0, 1.0, 0.5)
const DEFAULT_COLOR := Color.WHITE

var _logger := Logger.emplace("PngTuberRunner")

var handler: RunnerHandler = null

var _model: PngTuber = null

#-----------------------------------------------------------------------------#
# Builtin functions
#-----------------------------------------------------------------------------#

func _init() -> void:
	pass

func _ready() -> void:
	pass

#-----------------------------------------------------------------------------#
# Private functions
#-----------------------------------------------------------------------------#

#-----------------------------------------------------------------------------#
# Public functions
#-----------------------------------------------------------------------------#

## Tries to set the model and add it to the SceneTree.
func try_set_model(model: PngTuber) -> int:
	if _model != null:
		_logger.error("Model already exists, please unset the model first")
		return ERR_ALREADY_EXISTS
	
	_model = model
	add_child(_model)
	
	return OK

func feature_toggled(feature_name: String, enabled: bool) -> void:
	var feature: Variant = handler.features[feature_name]
	match feature_name:
		MicInput.FEATURE_NAME:
			if enabled:
				feature.threshold_reached.connect(func(reached: bool) -> void:
					# TODO testing
					if reached:
						_model.modulate = DEFAULT_COLOR
						_model.global_position.y = -20.0
					else:
						_model.modulate = DIM_COLOR
						_model.global_position.y = 0.0
				)
		_:
			pass
	pass
