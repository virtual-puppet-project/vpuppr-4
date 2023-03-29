class_name Runner3D
extends Node3D

## Runner for 3D models.
##
## Handles:
## - glb
## - vrm

var _logger := Logger.emplace("Runner3D")

var _model_gimbal := Node3D.new()
var _model: Node3D = null

var handler: RunnerHandler = null

#-----------------------------------------------------------------------------#
# Builtin functions
#-----------------------------------------------------------------------------#

func _ready() -> void:
	add_child(_model_gimbal)

#-----------------------------------------------------------------------------#
# Private functions
#-----------------------------------------------------------------------------#

#-----------------------------------------------------------------------------#
# Public functions
#-----------------------------------------------------------------------------#

## Tries to set the model and add it to the SceneTree.
func try_set_model(model: Node3D) -> int:
	if _model != null:
		_logger.error("Model already exists, please unset the model first")
		return ERR_ALREADY_EXISTS
	
	_model = model
	_model_gimbal.add_child(_model)
	
	return OK
