class_name AbstractTracker
extends Node

signal data_received()

var _logger: Logger = null

#-----------------------------------------------------------------------------#
# Builtin functions
#-----------------------------------------------------------------------------#

func _init(name: String) -> void:
	self.name = name
	
	_logger = Logger.emplace(name)

#-----------------------------------------------------------------------------#
# Private functions
#-----------------------------------------------------------------------------#

#-----------------------------------------------------------------------------#
# Public functions
#-----------------------------------------------------------------------------#

func start_receiver() -> int:
	_logger.error("Not yet implemented")
	return ERR_UNCONFIGURED

func stop_receiver() -> int:
	_logger.error("Not yet implemented")
	return ERR_UNCONFIGURED
