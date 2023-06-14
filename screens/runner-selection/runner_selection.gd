extends CanvasLayer

const RunnerItem: PackedScene = preload("res://screens/runner-selection/runner_item.tscn")
const Settings: PackedScene = preload("res://screens/settings.tscn")
const NewRunner: PackedScene = preload("res://screens/runner-selection/new_runner.tscn")

const LOGO_TWEEN_TIME: float = 1.5
const START_RUNNER_TWEEN_TIME: float = 0.5
const CLEAR_COLOR := Color("00000000")

const SortDirection := {
	"ASCENDING": "Ascending",
	"DESCENDING": "Descending"
}

var max_parallax_offset := Vector2(32.0, 18.0)

var _logger := Logger.emplace("RunnerSelection")

@onready
var _viewport: Viewport = get_viewport()
@onready
var _screen_center: Vector2 = _viewport.size / 2.0

@onready
var _fade: ColorRect = %Fade
@onready
var _ducks_background: TextureRect = %DucksBackground
@onready
var _duck: TextureRect = %Duck
@onready
var _logo: TextureRect = %Logo
@onready
var _sub_logo: TextureRect = %SubLogo
@onready
var _loading_spinner: CanvasLayer = %LoadingSpinner

@onready
var _parallax_elements: Array[TextureRect] = [
	_ducks_background,
	_duck,
	_logo,
	_sub_logo
]
## Initial positions for all parallax elements.
## TextureRect -> Vector2
var _parallax_initial_positions := {}

@onready
var _runner_container: PanelContainer = %RunnerContainer
@onready
var _runners: VBoxContainer = %Runners

var _last_sort_type: int = 0
## Needed so sorted can be un-reversed. Starts at 0 so everything is sorted as ascending to start.
var _last_last_sort_type: int = 0

var _settings_popup: Window = null

#-----------------------------------------------------------------------------#
# Builtin functions
#-----------------------------------------------------------------------------#

func _ready() -> void:
	_adapt_screen_size()
	
	var handle_popup_hide := func(node: Node) -> void:
		node.queue_free()
	
	%NewRunner.pressed.connect(func() -> void:
		var popup := NewRunner.instantiate()
		
		add_child(popup)
		popup.popup_centered_ratio()
		
		var config: RunnerData = await popup.close_requested
		if config == null:
			return
		
		_create_runner_item(config)
		ResourceSaver.save(
			config,
			"user://%s.tres" % config.name,
			ResourceSaver.FLAG_OMIT_EDITOR_PROPERTIES
		)
	)
	%Settings.pressed.connect(func() -> void:
		# Reuse the old settings popup
		if _settings_popup != null:
			_settings_popup.move_to_foreground()
			return
		
		_settings_popup = Window.new()
		_settings_popup.title = "VPupPr Settings"
		
		var settings := Settings.instantiate()
		_settings_popup.add_child(settings)
		
		add_child(_settings_popup)
		_settings_popup.popup_centered_ratio(0.5)
		
		var settings_hide := handle_popup_hide.bind(_settings_popup)
		_settings_popup.visibility_changed.connect(settings_hide)
		_settings_popup.close_requested.connect(settings_hide)
	)
	var sort_direction: Button = %SortDirection
	var sort_runners_popup: PopupMenu = %SortRunners.get_popup()
	sort_runners_popup.index_pressed.connect(func(idx: int) -> void:
		var reversed := idx == _last_sort_type
		if _last_sort_type == _last_last_sort_type:
			_last_last_sort_type = -1
			reversed = false
		else:
			_last_last_sort_type = _last_sort_type
		_last_sort_type = idx
		
		var children := _runners.get_children()
		for c in children:
			_runners.remove_child(c)
		
		match idx:
			0: # Last used
				children.sort_custom(func(a: Control, b: Control) -> bool:
					var dt_a: Datetime = a.last_used_datetime
					var dt_b: Datetime = b.last_used_datetime
					
					if (
						dt_a.year < dt_b.year or
						dt_a.month < dt_b.month or
						dt_a.day < dt_b.day or
						dt_a.hour < dt_b.hour or
						dt_a.minute < dt_b.minute or
						dt_a.second < dt_b.second
					):
						return true
					
					return false
				)
			1: # Name
				var titles: Array[String] = []
				children.sort_custom(func(a: Control, b: Control) -> bool:
					titles.clear()
					
					# Empty values displayed first
					if a.title.text.is_empty():
						return false
					if b.title.text.is_empty():
						return false
					if a.title.text == b.title.text:
						return false
					
					titles = [a.title.text, b.title.text]
					titles.sort()
					
					return titles.back() == b.title.text
				)
		
		if reversed:
			children.reverse()
			sort_direction.text = SortDirection.DESCENDING
		else:
			sort_direction.text = SortDirection.ASCENDING
		
		for c in children:
			_runners.add_child(c)
	)
	sort_direction.pressed.connect(func() -> void:
		# Basically virtually press the last option again, resulting in it being reversed
		_last_last_sort_type = -1 if _last_last_sort_type != _last_sort_type else _last_sort_type
		sort_runners_popup.index_pressed.emit(_last_sort_type)
	)
	
	var init_runners_thread := Thread.new()
	init_runners_thread.start(func() -> void:
		# TODO testing only, need to pull these values from metadata
		for data in (func() -> Array:
			var r := []
			
			const USER_DATA_DIR := "user://"
			
			var dir := DirAccess.open(USER_DATA_DIR)
			if dir == null:
				_logger.error("Unable to access user directory to load configs")
				return r
			
			dir.include_hidden = false
			dir.include_navigational = false
			
			dir.list_dir_begin()
			
			var file_name := ""
			while true:
				file_name = dir.get_next()
				
				if file_name.is_empty():
					break
				
				_logger.debug("Found file: %s" % file_name)
				
				if dir.current_is_dir() or file_name.get_extension().to_lower() != "tres":
					continue
				
				var config = load("%s%s" % [USER_DATA_DIR, file_name])
				if config == null or not config is RunnerData:
					continue
				
				r.push_back(config)
			
			dir.list_dir_end()
			
			return r
		).call():
			_create_runner_item(data)
	)
	
	_runner_container.hide()
	
	var logo_anchor: Control = %LogoAnchor
	var sub_logo_anchor: Control = %SubLogoAnchor
	
	var logo_anchor_to_anchor := logo_anchor.anchor_top - 0.2
	var sub_logo_to_anchor := sub_logo_anchor.anchor_top - 0.2
	
	# Needs to be declared early so the various closures can capture it
	var fade_tween := create_tween()
	fade_tween.tween_property(_fade, "color", CLEAR_COLOR, LOGO_TWEEN_TIME)
	
	var movement_tween := create_tween()
	movement_tween.stop()
	movement_tween.set_parallel(true).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	movement_tween.tween_property(logo_anchor, "anchor_top", logo_anchor_to_anchor, LOGO_TWEEN_TIME)
	movement_tween.tween_property(sub_logo_anchor, "anchor_top", sub_logo_to_anchor, LOGO_TWEEN_TIME)
	
	var cancel_intro_fade := func(event: InputEvent) -> void:
		if not event is InputEventMouseButton:
			return
		if not event.pressed:
			return
		
		_fade.color = CLEAR_COLOR
		fade_tween.finished.emit()
		fade_tween.kill()
	
	var cancel_intro_movement := func(event: InputEvent) -> void:
		if not event is InputEventMouseButton:
			return
		if not event.pressed:
			return
		
		logo_anchor.anchor_top = logo_anchor_to_anchor
		sub_logo_anchor.anchor_top = sub_logo_to_anchor
		# Pretend like the tween finished naturally
		movement_tween.finished.emit()
		movement_tween.kill()
	
	_fade.gui_input.connect(cancel_intro_fade)
	
	fade_tween.finished.connect(func() -> void:
		_fade.gui_input.disconnect(cancel_intro_fade)
		_fade.gui_input.connect(cancel_intro_movement)
		movement_tween.play()
	)
	
	movement_tween.finished.connect(func() -> void:
		_runner_container.show()
		_fade.mouse_filter = Control.MOUSE_FILTER_IGNORE
		
		var runner_tween := create_tween()
		runner_tween.tween_property(_runner_container, "modulate", Color.WHITE, LOGO_TWEEN_TIME / 2.0)
		
		_fade.gui_input.disconnect(cancel_intro_movement)
	)
	
	# Initially hidden because otherwise, the entire scene cannot be seen
	_fade.show()
	
	self.ready.connect(func() -> void:
		while init_runners_thread.is_alive():
			await get_tree().process_frame
		init_runners_thread.wait_to_finish()
		init_runners_thread = null
		
		sort_runners_popup.index_pressed.emit(0)
	)

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_WM_SIZE_CHANGED:
			_adapt_screen_size()

func _process(_delta: float) -> void:
	var mouse_diff: Vector2 = _screen_center - _viewport.get_mouse_position()
	mouse_diff.x = max(-max_parallax_offset.x, min(max_parallax_offset.x, mouse_diff.x))
	mouse_diff.y = max(-max_parallax_offset.y, min(max_parallax_offset.y, mouse_diff.y))
	
	_ducks_background.position = _ducks_background.position.lerp(
		_parallax_initial_positions[_ducks_background] - mouse_diff, 0.0025)
	
	_duck.position = _duck.position.lerp(_parallax_initial_positions[_duck] + mouse_diff, 0.005)
	_logo.position = _logo.position.lerp(_parallax_initial_positions[_logo] + mouse_diff, 0.005)
	_sub_logo.position = _sub_logo.position.lerp(
		_parallax_initial_positions[_sub_logo] + mouse_diff, 0.005)

#-----------------------------------------------------------------------------#
# Private functions
#-----------------------------------------------------------------------------#

func _adapt_screen_size() -> void:
	var current_screen_size := DisplayServer.screen_get_size(
		DisplayServer.window_get_current_screen())
	var scale_factor := Vector2(abs(current_screen_size / AM.DEFAULT_SCREEN_SIZE))
	
	_logger.debug("Using scale factor %s" % str(scale_factor))
	
	max_parallax_offset *= scale_factor
	
	for i in _parallax_elements:
		i.size *= scale_factor
		i.pivot_offset = i.size * 0.5
		i.position = -i.pivot_offset
		
		_parallax_initial_positions[i] = i.position

func _create_runner_item(data: RunnerData) -> void:
	var item := RunnerItem.instantiate()
	item.clicked.connect(func() -> void:
		_loading_spinner.start()
		var handler: RunnerContext = await RunnerContext.new(data)
		await handler.finished_loading
		_loading_spinner.stop()
		if handler.get_child_count() < 1:
			_logger.error(
				"An error occurred while loading the runner, declining to start handler")
			handler.queue_free()
			return
		
		var st := get_tree()
		
		var tween := st.create_tween()
		tween.tween_property(_fade, "color", Color.BLACK, START_RUNNER_TWEEN_TIME)
		
		await tween.finished
		
		st.root.add_child(handler)
		st.current_scene = handler
		
		# TODO (Tim Yuen) weird hack to force the fade effect to continue when the
		# current_scene has changed
		remove_child(_fade)
		var canvas_layer := CanvasLayer.new()
		canvas_layer.add_child(_fade)
		st.root.add_child(canvas_layer)
		
		self.visible = false
		
		tween = st.create_tween()
		tween.tween_property(_fade, "color", CLEAR_COLOR, START_RUNNER_TWEEN_TIME)
		
		await tween.finished
		
		canvas_layer.queue_free()
		
		self.queue_free()
	)
	
	_runners.add_child(item)
	
	item.init_favorite(data.favorite)
	item.title.text = data.name
	# TODO think about how to set this value from a RunnerData
#	item.model.text = data.model_path.get_file()
	item.last_used.text = data.last_used.to_string()
	item.last_used_datetime = data.last_used
	# TODO (Tim Yuen) currently needed since Godot threads don't like it when a function
	# directly throws an error in a thread. An indirect error is fine though
	item.init_preview(data.preview_path)

#-----------------------------------------------------------------------------#
# Public functions
#-----------------------------------------------------------------------------#

