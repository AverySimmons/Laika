extends Node2D

var num_bullets: int = 3

@onready var player: SpacePlayer = Data.space_player
@onready var enemy_bullet = preload("res://01_Source/03_Space/01_Player/00_Guns/enemy_bullet.tscn")
@onready var shoot_sound: AudioStreamPlayer = $Shoot

func shoot(projectiles: Node) -> void:
	var dir_to_player: Vector2
	if player == null:
		dir_to_player = Vector2(0, 1)
	else:
		dir_to_player = player.global_position - global_position
	var angle_to_player: float = dir_to_player.angle()
	angle_to_player -= TAU/16.
	shoot_sound.play()
	for bullet in range(num_bullets):
		var new_bullet = enemy_bullet.instantiate()
		new_bullet.global_position = global_position
		new_bullet.shoot(Vector2.from_angle(angle_to_player))
		projectiles.add_child(new_bullet)
		angle_to_player += TAU/16.
	return
