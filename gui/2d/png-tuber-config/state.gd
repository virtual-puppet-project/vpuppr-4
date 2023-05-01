extends VBoxContainer

var state_name := "Placeholder"

@onready
var default := %Default
@onready
var mouth_open := %MouthOpen
@onready
var blink := %Blink
@onready
var joy := %Joy
@onready
var angry := %Angry
@onready
var sorrow := %Sorrow
@onready
var fun := %Fun

#-----------------------------------------------------------------------------#
# Builtin functions
#-----------------------------------------------------------------------------#

func _ready() -> void:
	%StateName.text = state_name

#-----------------------------------------------------------------------------#
# Private functions
#-----------------------------------------------------------------------------#

#-----------------------------------------------------------------------------#
# Public functions
#-----------------------------------------------------------------------------#

func save(config: PngTuberConfig.FaceState) -> void:
	for i in PngTuber.Expressions.values():
		config.set(i, get(i).get_item_path())
