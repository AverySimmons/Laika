class_name Obstacle
extends Area2D

var radius: float
var hp: int
var velocity: Vector2

func _physics_process(delta: float) -> void:
	global_position += velocity * delta
	pass

func take_damage(damage: int) -> void:
	hp -= damage
	if hp <= 0:
		die()
	pass

func die() -> void:
	queue_free()
	pass
