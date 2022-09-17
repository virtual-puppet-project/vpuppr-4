class_name NodeUtils
extends Object

## Utility functions for nodes. Should never be created by itself.

#-----------------------------------------------------------------------------#
# Builtin functions                                                           #
#-----------------------------------------------------------------------------#

#-----------------------------------------------------------------------------#
# Connections                                                                 #
#-----------------------------------------------------------------------------#

#-----------------------------------------------------------------------------#
# Private functions                                                           #
#-----------------------------------------------------------------------------#

#-----------------------------------------------------------------------------#
# Public functions                                                            #
#-----------------------------------------------------------------------------#

#region Node

## Frees a Node. Meant to be used as a signal callback.
static func try_free(node: Node) -> void:
	if node == null or not is_instance_valid(node):
		Logger.global_log("NodeUtils", "Node is not valid, cannot free")
		return
	node.free()

## Queue frees a Node. Meant to be used as a signal callback.
static func try_queue_free(node: Node) -> void:
	if node == null or not is_instance_valid(node):
		Logger.global_log("NodeUtils", "Node is not valid, cannot queue_free")
		return
	node.queue_free()

#endregion

#region Control

## Sets the focus mode for a Control to FOCUS_NONE
static func no_focus(control: Control) -> void:
	control.focus_mode = Control.FOCUS_NONE

## Sets the horizontal size flags for a Control to SIZE_EXPAND_FILL
static func h_expand_fill(control: Control) -> void:
	control.size_flags_horizontal = Control.SIZE_EXPAND_FILL

## Sets the vertical size flags for a Control to SIZE_EXPAND_FILL
static func v_expand_fill(control: Control) -> void:
	control.size_flags_vertical = Control.SIZE_EXPAND_FILL

## Sets both the horizontal and vertical size flags for a Control to SIZE_EXPAND_FILL
static func all_expand_fill(control: Control) -> void:
	h_expand_fill(control)
	v_expand_fill(control)

#endregion
