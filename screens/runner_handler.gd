class_name RunnerHandler
extends Node

## Handler for all runners. Provides utility functions useful for all runners.

const MODEL_IMPORT_FLAGS: int = 1 + 2 + 4 + 8 + 16 + 32

## The logger for the RunnerHandler.
var _logger := Logger.emplace("RunnerHandler")

#-----------------------------------------------------------------------------#
# Builtin functions
#-----------------------------------------------------------------------------#

func _init(data: RunnerData) -> void:
	var fail_alert := func(text: String) -> void:
		_logger.error(text)
		OS.alert(text)
	
	if data == null:
		fail_alert.call("No runner data received, bailing out!")
		return
	
	var gui: Node = _try_load(data.gui_path)
	if gui == null:
		var fail_text := "Unable to load runner, bailing out!"
		_logger.error(fail_text)
		OS.alert(fail_text)
		return
	
	add_child(gui)
	
	var runner: Node = _try_load(data.runner_path)
	if runner == null:
		fail_alert.call("Unable to load runner, bailing out!")
		return
	
	add_child(runner)
	
	var model_thread := Thread.new()
	model_thread.start(func() -> Node:
		var model: Node = null
		
		match data.model_path.get_extension().to_lower():
			"tscn", "scn":
				var resource: PackedScene = load(data.model_path)
				if resource == null:
					return
				
				model = resource.instantiate()
			"glb":
				var gltf: GLTFDocument = GLTFDocument.new()
				var state: GLTFState = GLTFState.new()
				
				var err := gltf.append_from_file(data.model_path, state, MODEL_IMPORT_FLAGS)
				if err != OK:
					return null
				
				model = gltf.generate_scene(state)
			"vrm":
				var gltf: GLTFDocument = GLTFDocument.new()
				var vrm_extension: GLTFDocumentExtension = preload("res://addons/vrm/vrm_extension.gd").new()
				GLTFDocument.register_gltf_document_extension(vrm_extension)
				var state: GLTFState = GLTFState.new()
				
				var err := gltf.append_from_file(data.model_path, state, MODEL_IMPORT_FLAGS)
				if err != OK:
					GLTFDocument.unregister_gltf_document_extension(vrm_extension)
					return null
				
				model = gltf.generate_scene(state)
				GLTFDocument.unregister_gltf_document_extension(vrm_extension)
			_:
				pass
		
		return model
	)
	while model_thread.is_alive():
		await Engine.get_main_loop().process_frame
	
	var model: Node = model_thread.wait_to_finish()
	if model == null:
		fail_alert.call("Unable to load model!")
		return
	
	runner.try_set_model(model)

#-----------------------------------------------------------------------------#
# Private functions
#-----------------------------------------------------------------------------#

func _try_load(path: String) -> Node:
	var resource: Resource = load(path)
	if resource == null:
		return null
	
	return resource.new() if resource is GDScript else resource.instantiate()

#-----------------------------------------------------------------------------#
# Public functions
#-----------------------------------------------------------------------------#

