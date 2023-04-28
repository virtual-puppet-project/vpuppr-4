class_name GuiInterface
extends Object

const Methods := {
	## Takes a config param.
	SAVE = "save",
	
	## Returns a Array[int].
	CONTEXT_NEEDED = "context_needed"
}

static func implements(obj: Object) -> bool:
	for val in Methods.values():
		if not obj.has_method(val):
			return false
	
	return true
