extends ScrollContainer

var _logger := Logger.emplace("Rendering")

#-----------------------------------------------------------------------------#
# Builtin functions
#-----------------------------------------------------------------------------#

func _ready() -> void:
	var msaa_2d_button: OptionButton = %Msaa2D
	msaa_2d_button.select(AM.cm.metadata.msaa_2d)
	msaa_2d_button.item_selected.connect(func(idx: int) -> void:
		var vp := get_tree().root.get_viewport()
		match idx:
			0: # Disabled
				vp.msaa_2d = Viewport.MSAA_DISABLED
			1: # 2X
				vp.msaa_2d = Viewport.MSAA_2X
			2: # 4X
				vp.msaa_2d = Viewport.MSAA_4X
			3: # 8X
				vp.msaa_2d = Viewport.MSAA_8X
			_:
				_logger.error("Unhandled MSAA 2D value: %d" % idx)
				return
		
		AM.cm.metadata.msaa_2d = vp.msaa_2d
	)
	var msaa_3d_button: OptionButton = %Msaa3D
	msaa_3d_button.select(AM.cm.metadata.msaa_3d)
	msaa_3d_button.item_selected.connect(func(idx: int) -> void:
		var vp := get_tree().root.get_viewport()
		match idx:
			0: # Disabled
				vp.msaa_3d = Viewport.MSAA_DISABLED
			1: # 2X
				vp.msaa_3d = Viewport.MSAA_2X
			2: # 4X
				vp.msaa_3d = Viewport.MSAA_4X
			3: # 8X
				vp.msaa_3d = Viewport.MSAA_8X
			_:
				_logger.error("Unhandled MSAA 3D value: %d" % idx)
		
		AM.cm.metadata.msaa_3d = vp.msaa_3d
	)

#-----------------------------------------------------------------------------#
# Private functions
#-----------------------------------------------------------------------------#

#-----------------------------------------------------------------------------#
# Public functions
#-----------------------------------------------------------------------------#

