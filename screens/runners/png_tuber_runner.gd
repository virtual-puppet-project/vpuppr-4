class_name PngTuberRunner
extends Node2D

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
				feature.threshold_reached.connect(feature.handle.bind(_model))
			else:
				feature.threshold_reached.disconnect(feature.handle)
				# Reset the model
				feature.handle(true, _model)
		_:
			_logger.error("Unhandled feature %s %s" % [
				feature_name, "enabled" if enabled else "disabled"])
