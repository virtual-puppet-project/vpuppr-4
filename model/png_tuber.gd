class_name PngTuber
extends Node2D

const States := {
	FORWARD = "forward",
	LEFT = "left",
	RIGHT = "right",
	UP = "up",
	DOWN = "down",
	CUSTOM = "custom"
}

const Expressions := {
	DEFAULT = "default",
	MOUTH_OPEN = "mouth_open",
	BLINK = "blink",
	JOY = "joy",
	ANGRY = "angry",
	SORROW = "sorrow",
	FUN = "fun"
}

var context: RunnerContext = null

var _logger := Logger.emplace("PngTuber")

## Dictionary<String, Dictionary<String, Image>> [br]
## State -> Expression -> Image
var _sprites := {}
var _current_sprite: Sprite2D = null

#-----------------------------------------------------------------------------#
# Builtin functions
#-----------------------------------------------------------------------------#

func _init(config: PngTuberConfig = null) -> void:
	# TODO precalculate which sprites are valid so we can decline to switch to an empty sprite
	
	for state in States.values():
		_sprites[state] = {}

		var face_state: PngTuberFaceState = config.get(state)

		for expression in Expressions.values():
			var path: String = face_state.get(expression)
			if path.is_empty():
				_logger.debug("No data found for %s:%s" % [state, expression])
				continue

			var image := Image.load_from_file(path)
			if image.is_empty():
				_logger.error("Unable to load image from path %s" % path)
				continue

			var sprite := Sprite2D.new()
			sprite.texture = ImageTexture.create_from_image(image)

			add_child(sprite)
			sprite.hide()

			_sprites[state][expression] = sprite

func _ready() -> void:
	_current_sprite = _sprites[States.FORWARD][Expressions.DEFAULT]
	_current_sprite.show()

#-----------------------------------------------------------------------------#
# Private functions
#-----------------------------------------------------------------------------#

#-----------------------------------------------------------------------------#
# Public functions
#-----------------------------------------------------------------------------#

func change_sprite(state: String, expression: String) -> void:
	_current_sprite.hide()
	
	_current_sprite = _sprites[state][expression]
	_current_sprite.show()
