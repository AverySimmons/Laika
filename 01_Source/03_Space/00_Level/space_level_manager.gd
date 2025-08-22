extends Node2D

# Spawn Scaling ====================================================================================

@onready var meteor_spawner: Node2D = $MeteorSpawner
@onready var enemy_spawner: Node2D = $EnemySpawner
@onready var enemies: Node = $Enemies
@onready var meteors: Node = $Meteors
@onready var projectiles: Node = $Projectiles
@onready var player_scene = preload("res://01_Source/03_Space/01_Player/player_space.tscn")
var player: SpacePlayer

func _ready() -> void:
	meteor_spawner.meteors = meteors
	enemy_spawner.enemies = enemies
	enemy_spawner.projectiles = projectiles
	player = player_scene.instantiate()
	add_child(player)
	player.global_position = Vector2(292.5, 500)
	player.projectiles = projectiles
	pass

func handle_mouse(local_mouse_pos: Vector2, is_click: bool, is_held: bool) -> void:
	if is_held:
		Data.custom_mouse.cursor_type = Mouse.AIM
	else:
		Data.custom_mouse.cursor_type = Mouse.AIM2
	
	player.handle_mouse(local_mouse_pos, is_click, is_held)
