extends Node2D

export var gravity: float
export var min_input_strength: float
export var max_input_strength: float
export var input_strength_multiplier: float

var last_input_strength: float
var velocity: float

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	velocity = gravity - last_input_strength
	position.y += velocity * delta


func audio_input(input_strength: float):
	var clamped_input_strength = clamp(input_strength, min_input_strength, max_input_strength)
	clamped_input_strength = clamped_input_strength - min_input_strength
	last_input_strength = clamped_input_strength * input_strength_multiplier
	print(str(input_strength) + ' > ' + str(last_input_strength))
