class_name MicInputListener
extends Node

signal threshold_reached(state: bool)

const ASP_NAME := "MicInputNode"
const BUS_NAME: StringName = "Record"
const BUFFER_SIZE: int = 1024

const DIM_COLOR := Color(1.0, 1.0, 1.0, 0.5)
const DEFAULT_COLOR := Color.WHITE

var _aec: AudioEffectCapture = null
var _aesa: AudioEffectSpectrumAnalyzerInstance = null
var _asp: AudioStreamPlayer = null

var volume_threshold: float = 0.0005

#-----------------------------------------------------------------------------#
# Builtin functions
#-----------------------------------------------------------------------------#

func _ready() -> void:
	_setup_audio_resources()
	
	if not _asp.playing:
		_asp.play()

func _process(delta: float) -> void:
	if _aec.get_buffer_length_frames() >= BUFFER_SIZE:
		var volume: float = _aesa.get_magnitude_for_frequency_range(
			0, 10_000,AudioEffectSpectrumAnalyzerInstance.MAGNITUDE_AVERAGE).length()
		
		threshold_reached.emit(volume >= volume_threshold)
		
		_aec.clear_buffer()

#-----------------------------------------------------------------------------#
# Private functions
#-----------------------------------------------------------------------------#

func _setup_audio_resources() -> void:
	if AudioServer.get_bus_effect_count(1) < 2:
		_aec = AudioEffectCapture.new()
		_aec.buffer_length = BUFFER_SIZE
		AudioServer.add_bus_effect(1, _aec, 0)
		
		var spectrum_analyzer := AudioEffectSpectrumAnalyzer.new()
		spectrum_analyzer.buffer_length = BUFFER_SIZE
		AudioServer.add_bus_effect(1, spectrum_analyzer, 1)
		_aesa = AudioServer.get_bus_effect_instance(1, 1)
		
	else:
		_aec = AudioServer.get_bus_effect(1, 0)
		_aesa = AudioServer.get_bus_effect_instance(1, 1)
	
	var runner_handler := get_tree().current_scene
	_asp = runner_handler.get_node_or_null(ASP_NAME)
	if _asp == null:
		_asp = AudioStreamPlayer.new()
		_asp.name = ASP_NAME
		_asp.bus = BUS_NAME
		_asp.stream = AudioStreamMicrophone.new()
		
		runner_handler.add_child(_asp)

#-----------------------------------------------------------------------------#
# Public functions
#-----------------------------------------------------------------------------#

func handle(reached: bool, model: PngTuber) -> void:
	if reached:
		model.modulate = DEFAULT_COLOR
		model.global_position.y = -20.0
	else:
		model.modulate = DIM_COLOR
		model.global_position.y = 0.0
