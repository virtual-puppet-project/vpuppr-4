class_name PNGTuberRunner
extends Node2D

#-----------------------------------------------------------------------------#
# Builtin functions
#-----------------------------------------------------------------------------#

func _init() -> void:
	pass

#-----------------------------------------------------------------------------#
# Private functions
#-----------------------------------------------------------------------------#

#-----------------------------------------------------------------------------#
# Public functions
#-----------------------------------------------------------------------------#

func feature_toggled(feature_name: String, enabled: bool) -> void:
	match feature_name:
		MicInput.FEATURE_NAME:
			pass
		_:
			pass
	pass