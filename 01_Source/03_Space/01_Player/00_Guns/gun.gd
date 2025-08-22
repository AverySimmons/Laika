extends Node2D

var cooldown: float = 0.2
var cooldown_timer: float = 0

@onready var bullet_scene = preload("res://01_Source/03_Space/01_Player/00_Guns/bullet.tscn")

func _physics_process(delta: float) -> void:
	cooldown_timer = move_toward(cooldown_timer, 0, delta)
	pass

func handle_click(position: Vector2, projectiles: Node) -> void:
	if cooldown_timer != 0:
		return
	cooldown_timer = cooldown
	var bullet = bullet_scene.instantiate()
	bullet.global_position = global_position
	bullet.shoot(position)
	projectiles.add_child(bullet)
	pass
