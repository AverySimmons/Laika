extends Node2D

var speed: float = 40
var halfway: float = 360
var reached: bool = false
@onready var parent = get_parent()

func _physics_process(delta: float) -> void:
	if reached:
		return
	parent.global_position += Vector2(0, speed * delta)
	if parent.global_position.y >= halfway:
		reached = true
	pass
