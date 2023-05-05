class_name RunnerContext
extends Node

# TODO this is not good, needs to be rewritten

signal finished_loading()

## Handler for all runners. Provides utility functions useful for all runners.

const Context := {
	CONTEXT = "context",
	
	CONFIG = "config",
	GUI = "gui",
	RUNNER = "runner"
}

## The logger for the RunnerContext.
var _logger := Logger.emplace("RunnerContext")

var runner_data: RunnerData = null
var context: RunnerContext = self
var config: Resource = null
var gui: Node = null
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
		finished_loading.emit()
	
	if data == null:
		fail_alert.call("No runner data received, bailing out!")
		return
	
	runner_data = data
	config = data.config
	
	# TODO godot 4 is a fucking trash fire and this causes a data race somehow
	var loading_thread := Thread.new()
	loading_thread.start(func() -> Dictionary:
		var r := {
			runner = null,
			gui = null,
			model = null
		}

		var try_load := func(path: String) -> Variant:
			var resource: Resource = load(path)
			if resource == null:
				printerr("unable to load %s" % path)
				return null

			return resource.new() if resource is GDScript else resource.instantiate()

		r.runner = try_load.call(data.runner_path)
		r.gui = try_load.call(data.gui_path)

		if data.config is VrmConfig:
			match data.model_path.get_extension().to_lower():
				"tscn", "scn":
					var resource: PackedScene = load(data.model_path)
					if resource == null:
						return r
					
					r.model = resource.instantiate()
				"glb":
					var gltf: GLTFDocument = GLTFDocument.new()
					var state: GLTFState = GLTFState.new()

					var err := gltf.append_from_file(data.model_path, state)
					if err != OK:
						return r

					r.model = gltf.generate_scene(state)
					r.model.name = data.model_path.get_file()

					r.model.set_script(Puppet3D)
#				"vrm":
#					var gltf: GLTFDocument = GLTFDocument.new()
#					var vrm_extension: GLTFDocumentExtension = preload("res://addons/vrm/vrm_extension.gd").new()
#					GLTFDocument.register_gltf_document_extension(vrm_extension)
#					var state: GLTFState = GLTFState.new()
#
#					var err := gltf.append_from_file(data.model_path, state)
#					if err != OK:
#						GLTFDocument.unregister_gltf_document_extension(vrm_extension)
#						return r
#
#					r.model = gltf.generate_scene(state)
#					GLTFDocument.unregister_gltf_document_extension(vrm_extension)
		elif data.config is PngTuberConfig:
			if config.forward.default.is_empty():
				config.forward.default = PngTuberConfig.DEFAULT_IMAGE_PATH
			
			r.model = PngTuber.new(config)
		else:
			_logger.error("Unhandled config: %s" % str(data.config))

		return r
	)

	var st: SceneTree = Engine.get_main_loop()
	while loading_thread.is_alive():
		await st.process_frame

	var load_results: Dictionary = loading_thread.wait_to_finish()
	
	runner = load_results.runner
	if runner == null or _set_context(runner) != OK:
		fail_alert.call("Unable to load runner, bailing out!")
		return

	gui = load_results.gui
	if gui == null or _set_context(gui) != OK:
		fail_alert.call("Unable to load gui, bailing out!")
		return

	for datum in data.gui_menus:
		gui.add_menu(datum.menu_name, datum.path)
	
	var model: Node = load_results.model
	if model == null or _set_context(model) != OK:
		fail_alert.call("Unable to load model, bailing out!")
		return
	
	add_child(runner)
	add_child(gui)
	
	# TODO (Tim Yuen) this seems not good since there's no interface to compare against
	runner.try_set_model(model)
	
	# TODO (Tim Yuen) add hooks here? or maybe put them in ready?
	
	finished_loading.emit()

func _exit_tree() -> void:
	save()

#-----------------------------------------------------------------------------#
# Private functions
#-----------------------------------------------------------------------------#

func _try_load(path: String) -> Variant:
	var resource: Resource = load(path)
	if resource == null:
		printerr("unable to load %s" % path)
		return null
	
	return resource.new() if resource is GDScript else resource.instantiate()

func _set_context(obj: Object) -> int:
	obj.set(Context.CONTEXT, self)
	
	# This is a bit backwards but `set` will do nothing if the property does not exist.
	if obj.get(Context.CONTEXT) == null:
		return ERR_DOES_NOT_EXIST
	
	return OK

#-----------------------------------------------------------------------------#
# Public functions
#-----------------------------------------------------------------------------#

static func get_current() -> RunnerContext:
	var context: Variant = Engine.get_main_loop().current_scene
	if not context is RunnerContext:
		return null
	
	return context

func save() -> Error:
	return ResourceSaver.save(
		runner_data,
		"user://%s.tres" % runner_data.name,
		ResourceSaver.FLAG_OMIT_EDITOR_PROPERTIES
	)

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
