extends Node2D

var record_bus_id
var record_effect


func _ready():
	record_bus_id = AudioServer.get_bus_index('Record')
	record_effect = AudioServer.get_bus_effect(record_bus_id, 0)
	record_effect.set_recording_active(true)
	

func _process(delta):
	if record_effect.is_recording_active():
		var voice_pover = AudioServer.get_bus_peak_volume_left_db(record_bus_id, 0)
		print(voice_pover)
