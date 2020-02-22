extends Node2D

export var speed: float


func _physics_process(delta):
	position.x += speed * delta
	if position.x > get_viewport().size.x + 20:
		queue_free()
		
	if position.x < -20:
		queue_free()
