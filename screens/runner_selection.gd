extends CanvasLayer

const RunnerItem: PackedScene = preload("res://screens/runner-selection/runner_item.tscn")

const LOGO_TWEEN_TIME: float = 2.0

var max_parallax_offset := Vector2(32.0, 18.0)

var _logger := Logger.emplace("RunnerSelection")

@onready
var _viewport: Viewport = get_viewport()
@onready
var _screen_center: Vector2 = _viewport.size / 2.0

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
var runners: VBoxContainer = %Runners
var _init_runners_thread := Thread.new()

#-----------------------------------------------------------------------------#
# Builtin functions
#-----------------------------------------------------------------------------#

func _ready() -> void:
	_adapt_screen_size()
	
	_init_runners_thread.start(func() -> void:
		# TODO testing only, need to pull these values from metadata
		for i in [{
			"favorite": true,
			"preview": "res://assets/VpupprDuck.png",
			"title": "Testing",
			"model": "my_model_name.vrm",
			"last_used": "some:date"
		},
		{
			"favorite": true,
			"preview": "res://assets/VpupprDuck.png",
			"title": "Another runner i guess",
			"model": "SomeModel.glb",
			"last_used": "some:date"
		}]:
			var item := RunnerItem.instantiate()
			item.clicked.connect(func() -> void:
				_logger.info(item.to_string())
			)
			
			runners.add_child(item)
			
			item.init_favorite(i.favorite)
			item.title.text = i.title
			item.model.text = i.model
			item.last_used.text = i.last_used
			
			var preview: Texture = load(i.preview)
			if preview == null:
				_logger.error("Unable to load preview for %s from %s" % [i.title, i.preview])
				continue
			
			item.preview.texture = preview
	)
	
	var logo_anchor: Control = %LogoAnchor
	var sub_logo_anchor: Control = %SubLogoAnchor
	
	var logo_anchor_to_anchor := logo_anchor.anchor_top - 0.2
	var sub_logo_to_anchor := sub_logo_anchor.anchor_top - 0.2
	
	var tween := get_tree().create_tween()
	tween.set_parallel(true).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(logo_anchor, "anchor_top", logo_anchor_to_anchor, LOGO_TWEEN_TIME)
	tween.tween_property(sub_logo_anchor, "anchor_top", sub_logo_to_anchor, LOGO_TWEEN_TIME)
	
	var background: ColorRect = $Background
	
	var tween_finished_callback := func() -> void:
		runners.show()
	
	background.gui_input.connect(func(event: InputEvent) -> void:
		if not event is InputEventMouseButton:
			return
		if not event.pressed:
			return
		# TODO not sure how to disconnect this signal cleanly, so just ignore any inputs if
		# the tween is finished for now
		if not tween.is_valid():
			return
		
		tween.kill()
		logo_anchor.anchor_top = logo_anchor_to_anchor
		sub_logo_anchor.anchor_top = sub_logo_to_anchor
		tween_finished_callback.call())
	
	tween.finished.connect(tween_finished_callback)
	
	tween.play()

func _exit_tree() -> void:
	_init_runners_thread.wait_to_finish()

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_WM_SIZE_CHANGED:
			_adapt_screen_size()

func _process(delta: float) -> void:
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

