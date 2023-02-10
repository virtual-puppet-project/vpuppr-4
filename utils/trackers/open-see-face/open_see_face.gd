class_name OpenSeeFace
extends AbstractTracker

const PACKET_FRAME_SIZE: int = 8 + 4 + 2 * 4 + 2 * 4 + 1 + 4 + 3 * 4 + 3 * 4 + 4 * 4 + 4 * 68 + 4 * 2 * 68 + 4 * 3 * 70 + 4 * 14

const MAX_TRACKER_FPS: int = 144
const MAX_FIT_3D_ERROR: float = 100.0

var server_poll_interval: float = 1.0 / MAX_TRACKER_FPS

var server: UDPServer = null
var connection: PacketPeerUDP = null

var receive_thread: Thread = null
var stop_reception := false

var tracker_pid: int = -1

#-----------------------------------------------------------------------------#
# Builtin functions
#-----------------------------------------------------------------------------#

func _init(name: String) -> void:
	super(name)

#-----------------------------------------------------------------------------#
# Private functions
#-----------------------------------------------------------------------------#

#-----------------------------------------------------------------------------#
# Public functions
#-----------------------------------------------------------------------------#

func start_tracker() -> int:
	# TODO pull values from config instead
	_logger.info("Starting OpenSeeFace tracker")
	
	var pid := OS.execute("%s/OpenSeeFace/facetracker%s" % [
		"res://resources/", ".exe" if OS.get_name().to_lower() == "windows" else ""
	],
	[
		"--ip", "127.0.0.1",
		"--port", "11573"
	])
	
	return OK

func stop_tracker() -> int:
	
	return OK
