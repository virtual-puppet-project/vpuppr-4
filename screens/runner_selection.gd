extends CanvasLayer

const RunnerItem: PackedScene = preload("res://screens/runner-selection/runner_item.tscn")

const LOGO_TWEEN_TIME: float = 1.5
const START_RUNNER_TWEEN_TIME: float = 0.5
const CLEAR_COLOR := Color("00000000")

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
var _runner_container: VBoxContainer = %RunnerContainer
@onready
var _runners: VBoxContainer = %Runners
var _init_runners_thread := Thread.new()

#-----------------------------------------------------------------------------#
# Builtin functions
#-----------------------------------------------------------------------------#

func _ready() -> void:
	_adapt_screen_size()
	
	_init_runners_thread.start(func() -> void:
		# TODO testing only, need to pull these values from metadata
		for i in (func() -> Array:
			var r := []
			
			for i in 10:
				var d0 := RunnerData.new()
				d0.name = "Test 0"
				d0.runner_path = "res://screens/runners/runner_3d.tscn"
				d0.gui_path = "res://gui/standard_gui.tscn"
				d0.model_path = "some/path/to/model.vrm"
				d0.preview_path = "res://assets/VpupprDuck.png"
				d0.last_used.day = 123
				d0.favorite = true
				
				r.append(d0)
				
				var d1 := RunnerData.new()
				d1.name = "Some other data"
				d1.runner_path = "res://screens/runners/runner_3d.tscn"
				d1.gui_path = "res://gui/standard_gui.tscn"
				d1.model_path = "some/other/model.glb"
				
				r.append(d1)
				
				var d2 := RunnerData.new()
				d2.name = "Bad data"
				d2.runner_path = ""
				d2.gui_path = ""
				d2.model_path = ""
				
				r.append(d2)
			
			return r
		).call():
			var item := RunnerItem.instantiate()
			item.clicked.connect(func() -> void:
				var handler := RunnerHandler.new(i)
				if handler.get_child_count() < 1:
					_logger.error(
						"An error occurred while loading the runner, declining to start handler")
					handler.free()
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
				st.root.add_child(_fade)
				
				self.visible = false
				
				tween = st.create_tween()
				tween.tween_property(_fade, "color", CLEAR_COLOR, START_RUNNER_TWEEN_TIME)
				
				await tween.finished
				
				_fade.queue_free()
				
				self.queue_free()
			)
			
			_runners.add_child(item)
			
			item.init_favorite(i.favorite)
			item.title.text = i.name
			item.model.text = i.model_path.get_file()
			item.last_used.text = i.last_used.to_string()
			# TODO (Tim Yuen) currently needed since Godot threads don't like it when a function
			# directly throws an error in a thread. An indirect error is fine though
			item.init_preview(i.preview_path)
	)
	
	var logo_anchor: Control = %LogoAnchor
	var sub_logo_anchor: Control = %SubLogoAnchor
	
	var logo_anchor_to_anchor := logo_anchor.anchor_top - 0.2
	var sub_logo_to_anchor := sub_logo_anchor.anchor_top - 0.2
	
	var tween := get_tree().create_tween()
	tween.stop()
	tween.set_parallel(true).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(logo_anchor, "anchor_top", logo_anchor_to_anchor, LOGO_TWEEN_TIME)
	tween.tween_property(sub_logo_anchor, "anchor_top", sub_logo_to_anchor, LOGO_TWEEN_TIME)
	tween.tween_property(_fade, "color", CLEAR_COLOR, LOGO_TWEEN_TIME)
	
	var tween_finished_callback := func() -> void:
		_runner_container.show()
		_fade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	var cancel_intro_fade := func(event: InputEvent) -> void:
		if not event is InputEventMouseButton:
			return
		if not event.pressed:
			return
		if not tween.is_valid():
			return
		
		logo_anchor.anchor_top = logo_anchor_to_anchor
		sub_logo_anchor.anchor_top = sub_logo_to_anchor
		_fade.color = CLEAR_COLOR
		# Pretend like the tween finished naturally
		tween.finished.emit()
		tween.kill()
	
	# Initially hidden because otherwise, the entire scene cannot be seen
	_fade.show()
	_fade.gui_input.connect(cancel_intro_fade)
	
	tween.finished.connect(func() -> void:
		tween_finished_callback.call()
		_fade.gui_input.disconnect(cancel_intro_fade)
	)
	
	tween.play()

func _exit_tree() -> void:
	_init_runners_thread.wait_to_finish()

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

#-----------------------------------------------------------------------------#
# Public functions
#-----------------------------------------------------------------------------#

