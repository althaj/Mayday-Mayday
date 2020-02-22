extends Node

var record_bus_id
var record_effect
var playing = false
var paused = false

var player

var enemy_scene = preload("res://Scenes/Enemy.tscn")
var player_scene = preload("res://Scenes/Player.tscn")
var explosion_scene = preload("res://Scenes/PlayerExplosion.tscn")


func _ready():
	randomize()
	
	record_bus_id = AudioServer.get_bus_index("Record")
	record_effect = AudioServer.get_bus_effect(record_bus_id, 0)
	record_effect.set_recording_active(true)
	$EnemySpawnTimer.connect("timeout", self, "_on_enemy_spawn")
	$GameOverTimer.connect("timeout", self, "_on_game_over_timer")


func _process(delta):
	if record_effect.is_recording_active():
		var voice_power = AudioServer.get_bus_peak_volume_left_db(record_bus_id, 0)
		if playing:
			player.audio_input(voice_power)
		else:
			if !paused and voice_power > -20:
				_start_game()


func _on_player_death():
	playing = false
	paused = true
	$GameOverTimer.start()
	$EnemySpawnTimer.stop()
	
	var explosion = explosion_scene.instance()
	$GameLayer.add_child(explosion)
	explosion.position = player.position
	explosion.get_node("CPUParticles2D").set_emitting(true)
	player.queue_free()
	
func _on_game_over_timer():
	$UILayer/UI/GameOver.visible = true
	paused = false


func _on_enemy_spawn():
	var enemy = enemy_scene.instance()
	$GameLayer.add_child(enemy)
	enemy.position.x = get_viewport().size.x + 40
	$EnemySpawnTimer.wait_time = max($EnemySpawnTimer.wait_time - 0.1, 0.75)


func _start_game():
	for i in range(0, $GameLayer.get_child_count()):
		$GameLayer.get_child(i).queue_free()
	
	$UILayer/UI/GameOver.visible = false
	$UILayer/UI/NewGame.visible = false
	playing = true
	player = player_scene.instance()
	$GameLayer.add_child(player)
	player.position.x = 100
	player.position.y = 240
	player.connect("player_death", self, "_on_player_death")
	$EnemySpawnTimer.start()
