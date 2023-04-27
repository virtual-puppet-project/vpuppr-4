class_name PngTuber
extends Node2D

var context: RunnerHandler = null

## PngTuber state -> [Sprite]
var _sprites := {}

#-----------------------------------------------------------------------------#
# Builtin functions
#-----------------------------------------------------------------------------#

func _init() -> void:
	# TODO testing
	for i in ["res://assets/VpupprDuck.png"]:
		var sprite := Sprite2D.new()
		
		var image := Image.load_from_file(i)
		sprite.texture = ImageTexture.create_from_image(image)
		
		add_child(sprite)

#-----------------------------------------------------------------------------#
# Private functions
#-----------------------------------------------------------------------------#

#-----------------------------------------------------------------------------#
# Public functions
#-----------------------------------------------------------------------------#
