extends Node2D

export var min_height: float
export var max_height: float

var speed: float
var height_change_speed: float
var is_rising: bool = false

var enemy_shot = preload("res://Scenes/EnemyShot.tscn")
var explosion_scene = preload("res://Scenes/Explosion.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	if rand_range(0, 1) > 0.5:
		is_rising = true
		
	position.y = rand_range(min_height, max_height)
	height_change_speed = rand_range(30, 60)
	speed = rand_range(125, 160)
	
	$Area2D.connect("area_entered", self, "_on_area_enetered")
	$ShootTimer.connect("timeout", self, "_on_enemy_shoot")


func _physics_process(delta):
	if position.x < -40:
		queue_free()
	
	position.x -= speed * delta
	
	if is_rising:
		if position.y > min_height:
			position.y -= height_change_speed * delta
		else:
			position.y += height_change_speed * delta
			is_rising = false
	else:
		if position.y < max_height:
			position.y += height_change_speed * delta
		else:
			position.y -= height_change_speed * delta
			is_rising = true


func _on_area_enetered(area):
	if area.is_in_group('player_projectile'):
		var explosion = explosion_scene.instance()
		get_parent().add_child(explosion)
		explosion.position = position
		explosion.get_node("CPUParticles2D").set_emitting(true)
		queue_free()
	
	
func _on_enemy_shoot():
	var shot = enemy_shot.instance()
	get_parent().add_child(shot)
	shot.position.y = position.y
	shot.position.x = position.x - 50
	$ShootStream.play()
