class_name TrackerManager
extends RefCounted

signal data_received(data: Variant)

var _trackers := {}

#-----------------------------------------------------------------------------#
# Builtin functions
#-----------------------------------------------------------------------------#

#-----------------------------------------------------------------------------#
# Private functions
#-----------------------------------------------------------------------------#

#-----------------------------------------------------------------------------#
# Public functions
#-----------------------------------------------------------------------------#

func add_tracker(name: String, tracker: AbstractTracker) -> int:
	if _trackers.has(name):
		return ERR_ALREADY_EXISTS
	
	_trackers[name] = tracker
	tracker.data_received.connect(func(data: Variant) -> void:
		data_received.emit(data)
	)
	
	return OK

func remove_tracker(name: String) -> int:
	if not _trackers.erase(name):
		return ERR_DOES_NOT_EXIST
	
	return OK

func start(args: Dictionary) -> int:
	for tracker_name in args:
		if not _trackers.has(tracker_name):
			return ERR_DOES_NOT_EXIST
		if not args[tracker_name] is Array:
			return ERR_INVALID_PARAMETER
	
	for tracker_name in args:
		_trackers[tracker_name].callv("start", args[tracker_name])
	
	return OK

func stop() -> void:
	for tracker in _trackers.values():
		tracker.stop()
