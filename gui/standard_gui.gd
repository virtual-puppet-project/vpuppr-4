extends CanvasLayer

@onready
var _menu_items := %MenuItems

var _grabber_grabbed := false

#-----------------------------------------------------------------------------#
# Builtin functions
#-----------------------------------------------------------------------------#

func _ready() -> void:
	%App.pressed.connect(func() -> void:
		pass
	)
	%Debug.pressed.connect(func() -> void:
		pass
	)
	%Help.pressed.connect(func() -> void:
		pass
	)
	
#	var osf := OpenSeeFace.new()
#	osf.data_received.connect(func(data: OpenSeeFaceData) -> void:
#		print(data.eye_left, data.eye_right)
#	)
#
#	add_child(osf)
#
#	print("osf added as child")
#
#	var err := osf.start(0)
#	if err != OK:
#		print(err)
	
#	var mf := MeowFace.new()
#	mf.data_received.connect(func(data: MeowFaceData) -> void:
#		print(JSON.stringify(data.get_blend_shapes(), "\t"))
#	)
#	add_child(mf)
#
#	mf.start("192.168.88.229", 21412)

#-----------------------------------------------------------------------------#
# Private functions
#-----------------------------------------------------------------------------#

#-----------------------------------------------------------------------------#
# Public functions
#-----------------------------------------------------------------------------#

