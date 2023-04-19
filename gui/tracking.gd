extends PanelContainer

#-----------------------------------------------------------------------------#
# Builtin functions
#-----------------------------------------------------------------------------#

func _ready() -> void:
	%StopAllTrackers.pressed.connect(func() -> void:
		AM.tm.stop()
	)
	
	# TODO testing
	%MeowFace.set_pressed_no_signal(AM.tm.is_running(MeowFace.identifier()))
	%MeowFace.toggled.connect(func(enabled: bool) -> void:
		if enabled:
			var mf := MeowFace.new()
			AM.tm.add_tracker("MeowFace", mf)

			# TODO don't use this when you actually implement the ui
			var model: Node = get_tree().current_scene.runner._model
			AM.tm.data_received.connect(func(data: MeowFaceData) -> void:
				model._skeleton.set_bone_pose_rotation(model._head_bone, Quaternion.from_euler(data.head_rotation * 0.02))
			)
			AM.tm.start({"MeowFace": ["192.168.88.229", 21412]})
		else:
			AM.tm.remove_tracker("MeowFace")
	)

#-----------------------------------------------------------------------------#
# Private functions
#-----------------------------------------------------------------------------#

#-----------------------------------------------------------------------------#
# Public functions
#-----------------------------------------------------------------------------#

