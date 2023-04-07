class_name Puppet3D
extends Node3D

var _logger := Logger.emplace("Puppet3D")

var _skeleton: Skeleton3D = null
var _head_bone: int = -1

#-----------------------------------------------------------------------------#
# Builtin functions
#-----------------------------------------------------------------------------#

func _ready() -> void:
	_skeleton = find_child("Skeleton3D")
	if _skeleton == null:
		_logger.error("No skeleton found")
		return
	
	_head_bone = _skeleton.find_bone("head")

#-----------------------------------------------------------------------------#
# Private functions
#-----------------------------------------------------------------------------#

#-----------------------------------------------------------------------------#
# Public functions
#-----------------------------------------------------------------------------#

