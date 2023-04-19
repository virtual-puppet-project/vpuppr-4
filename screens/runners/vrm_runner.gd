class_name VRMRunner
extends Node3D

## Runner for 3D models.
##
## Handles:
## - glb
## - vrm

var _logger := Logger.emplace("Runner3D")

var _model_gimbal: Node3D = Node3D.new()
var _model: Puppet3D = null

var handler: RunnerHandler = null

#-----------------------------------------------------------------------------#
# Builtin functions
#-----------------------------------------------------------------------------#

func _ready() -> void:
	_model_gimbal.name = "ModelGimbal"
	add_child(_model_gimbal)

func _physics_process(delta: float) -> void:
	pass

#-----------------------------------------------------------------------------#
# Private functions
#-----------------------------------------------------------------------------#

#-----------------------------------------------------------------------------#
# Public functions
#-----------------------------------------------------------------------------#

## Tries to set the model and add it to the SceneTree.
func try_set_model(model: Puppet3D) -> int:
	if _model != null:
		_logger.error("Model already exists, please unset the model first")
		return ERR_ALREADY_EXISTS
	
	_model = model
	_model_gimbal.add_child(_model)
	
	return OK

func get_model() -> Node3D:
	if _model == null:
		_logger.error("Tried to get null model")
	
	return _model

func feature_toggled(feature_name: String, enabled: bool) -> void:
	match feature_name:
		MicInput.FEATURE_NAME:
			pass
		_:
			pass
	pass
