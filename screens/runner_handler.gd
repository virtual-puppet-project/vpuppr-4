class_name RunnerHandler
extends Node

## Handler for all runners. Provides utility functions useful for all runners.

## The logger for the RunnerHandler.
var _logger := Logger.emplace("RunnerHandler")

var runner: Node = null

## Various features available in the runner. Features can be added or removed.
var features := {}

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
	
	for datum in data.gui_menus:
		gui.add_menu(datum.menu_name, datum.path)
	
	add_child(gui)
	
	runner = _try_load(data.runner_path)
	if runner == null:
		fail_alert.call("Unable to load runner, bailing out!")
		return
	
	runner.set("handler", self)
	
	add_child(runner)
	
	# TODO need better way to set model scripts
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
				
				var err := gltf.append_from_file(data.model_path, state)
				if err != OK:
					return null
				
				model = gltf.generate_scene(state)
				model.name = data.model_path.get_file()
				
				model.set_script(Puppet3D)
			"vrm":
				var gltf: GLTFDocument = GLTFDocument.new()
				var vrm_extension: GLTFDocumentExtension = preload("res://addons/vrm/vrm_extension.gd").new()
				GLTFDocument.register_gltf_document_extension(vrm_extension)
				var state: GLTFState = GLTFState.new()
				
				var err := gltf.append_from_file(data.model_path, state)
				if err != OK:
					GLTFDocument.unregister_gltf_document_extension(vrm_extension)
					return null
				
				model = gltf.generate_scene(state)
				GLTFDocument.unregister_gltf_document_extension(vrm_extension)
			"png":
#				var png: Image
				
				# TODO testing
				model = PngTuber.new()
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
	
	# TODO (Tim Yuen) this seems not good since there's no interface to compare against
	runner.try_set_model(model)
	
	# TODO (Tim Yuen) add hooks here? or maybe put them in ready?

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

func add_feature(feature_name: StringName, object: Object) -> Error:
	if features.has(feature_name):
		return ERR_ALREADY_IN_USE
	
	features[feature_name] = object
	if object is Node:
		add_child(object)
	
	runner.feature_toggled(feature_name, true)
	
	return OK

func remove_feature(feature_name: StringName) -> Variant:
	if not features.has(feature_name):
		return null
	
	var feature: Variant = features[feature_name]
	if feature is Node:
		remove_child(feature)
	
	runner.feature_toggled(feature_name, false)
	
	features.erase(feature_name)
	
	return feature
