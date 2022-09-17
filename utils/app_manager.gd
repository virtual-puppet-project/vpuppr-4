class_name AppManager
extends Node

var logger: Logger

#region Debounce

## Time between debounces
const DEBOUNCE_TIME: float = 3.0
## Counter for debouncing. Resets once it reaches the DEBOUCE_TIME
var debounce_counter: float = 0.0
## Whether or not the debounce counter should be ticking
var should_save := false

#endregion

#-----------------------------------------------------------------------------#
# Builtin functions                                                           #
#-----------------------------------------------------------------------------#

func _init() -> void:
	pass

func _ready() -> void:
	
	logger = Logger.emplace("AppManager")
	
	tree_exiting.connect(func():
		# TODO check env and see if the config should be saved
		
		logger.info("Exiting. おやすみ。")
	)
	
	logger.info("Started. おはよう。")

#-----------------------------------------------------------------------------#
# Connections                                                                 #
#-----------------------------------------------------------------------------#

#-----------------------------------------------------------------------------#
# Private functions                                                           #
#-----------------------------------------------------------------------------#

#-----------------------------------------------------------------------------#
# Public functions                                                            #
#-----------------------------------------------------------------------------#

