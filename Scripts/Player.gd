extends Node2D

signal player_death

export var gravity: float
export var min_input_strength: float
export var max_input_strength: float
export var input_strength_multiplier: float

export var max_position: float
export var min_position: float

var last_input_strength: float
var velocity: float

var player_shot = preload("res://Scenes/PlayerShot.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	$ShootTimer.connect("timeout", self, "_on_player_shoot")
	$Area2D.connect("area_entered", self, "_on_area_enetered")


func _physics_process(delta):
	velocity = gravity - last_input_strength
	var desired_position = position.y + velocity * delta
	position.y = clamp(desired_position, min_position, desired_position)
	
	if position.y > max_position:
		emit_signal('player_death')


func audio_input(input_strength: float):
	var clamped_input_strength = clamp(input_strength, min_input_strength, max_input_strength)
	clamped_input_strength = clamped_input_strength - min_input_strength
	last_input_strength = clamped_input_strength * input_strength_multiplier


func _on_player_shoot():
	var shot = player_shot.instance()
	get_parent().add_child(shot)
	shot.position.y = position.y
	shot.position.x = position.x + 50
	$ShootStream.play()
	
	
func _on_area_enetered(area):
	if area.is_in_group('enemy'):
		emit_signal('player_death')
