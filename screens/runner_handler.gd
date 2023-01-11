class_name RunnerHandler
extends Node

## Handler for all runners. Provides utility functions useful for all runners.

## The logger for the RunnerHandler.
var _logger := Logger.emplace("RunnerHandler")

## The thread for background loading of resources. Generally used for 3D models.
var _load_thread: Thread = null

#-----------------------------------------------------------------------------#
# Builtin functions
#-----------------------------------------------------------------------------#

func _init(data: RunnerData = null) -> void:
	if data == null:
		pass
	
	var runner = _try_load_from_path(data.runner_path)
	if runner == null:
		var failure_text := "Failed to load runner at path %s" % data.runner_path
		_logger.error(failure_text)
		OS.alert(failure_text)
		
		return
	
	runner.set("handler", self)
	if runner.get("handler") == null:
		_logger.info("Unable to set handler on runner, things might not work correctly")
	
	add_child(runner)

#-----------------------------------------------------------------------------#
# Private functions
#-----------------------------------------------------------------------------#

func _try_load_from_path(path: String) -> Node:
	if not FileAccess.file_exists(path):
		_logger.error("File does not exist at %s" % path)
		return null
	
	var runner = load(path)
	if runner != null:
		if runner is PackedScene:
			return runner.instantiate()
		elif runner is GDScript:
			return runner.new()
		else:
			_logger.error("Unsupported Resource type loaded from %s" % path)
			return null
	
	var file := FileAccess.open(path, FileAccess.READ)
	if file != null:
		var contents := file.get_as_text()
		
		match path.get_extension().to_lower():
			"gd":
				var gdscript := GDScript.new()
				gdscript.source_code = contents
				if gdscript.reload() != OK:
					_logger.error("Unable to load GDScript code from %s" % path)
					return null
				
				return gdscript.new()
			"tscn", "scn":
				_logger.error("Loading arbitrary tscn and scn files is not yet implemented")
			_:
				_logger.error("Unsupported file format %s" % path.get_extension())
	
	return null

#-----------------------------------------------------------------------------#
# Public functions
#-----------------------------------------------------------------------------#

