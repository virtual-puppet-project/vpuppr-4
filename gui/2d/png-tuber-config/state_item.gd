extends VBoxContainer

@export
var item_name := "Placeholder"

@onready
var item_path := %ItemPath
@onready
var open_button := %Open
@onready
var status := %Status
@onready
var preview := %Preview

#-----------------------------------------------------------------------------#
# Builtin functions
#-----------------------------------------------------------------------------#

func _ready() -> void:
	%ItemName.text = item_name
	
	# TODO stub

#-----------------------------------------------------------------------------#
# Private functions
#-----------------------------------------------------------------------------#

#-----------------------------------------------------------------------------#
# Public functions
#-----------------------------------------------------------------------------#

func get_item_path() -> String:
	return item_path.text
