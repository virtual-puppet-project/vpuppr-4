class_name AppManager
extends Node

## The main singleton manager.

const DEFAULT_SCREEN_SIZE := Vector2i(1600, 900)

## Logger for the AppManager.
var _logger := Logger.emplace("AppManager")

var cm: ConfigManager = null
var tm: TrackerManager = null

#region Debounce

## Time between debounces.
const DEBOUNCE_TIME: float = 3.0
## Counter for debouncing. Resets once it reaches the DEBOUCE_TIME.
var debounce_counter: float = 0.0
## Whether or not the debounce counter should be ticking.
var should_save := false

#endregion

#-----------------------------------------------------------------------------#
# Builtin functions
#-----------------------------------------------------------------------------#

func _init() -> void:
	cm = ConfigManager.new()
	tm = TrackerManager.new()

func _ready() -> void:
	
	_logger.info("Started. おはよう。")

func _exit_tree() -> void:
	cm.free()
	
	# TODO check env and see if the config should be saved

	_logger.info("Exiting. おやすみ。")

#-----------------------------------------------------------------------------#
# Private functions
#-----------------------------------------------------------------------------#

#-----------------------------------------------------------------------------#
# Public functions
#-----------------------------------------------------------------------------#
