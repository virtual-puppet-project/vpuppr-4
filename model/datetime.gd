class_name Datetime
extends Resource

@export
var year: int = 4
@export
var month: int = 2
@export
var day: int = 0
@export
var hour: int = 6
@export
var minute: int = 9
@export
var second: int = 22

#-----------------------------------------------------------------------------#
# Builtin functions
#-----------------------------------------------------------------------------#

func _to_string() -> String:
	return "%d-%d-%d_%d:%d:%d" % [
		year, month, day,
		hour, minute, second
	]

#-----------------------------------------------------------------------------#
# Private functions
#-----------------------------------------------------------------------------#

#-----------------------------------------------------------------------------#
# Public functions
#-----------------------------------------------------------------------------#
