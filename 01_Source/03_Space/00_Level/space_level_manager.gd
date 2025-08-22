extends Node2D

@onready var starlayer_1: CPUParticles2D = $bg/starlayer1
@onready var starlayer_2: CPUParticles2D = $bg/starlayer2
@onready var starlayer_3: CPUParticles2D = $bg/starlayer3
@onready var starlayer_4: CPUParticles2D = $bg/starlayer4


@export var space_scale = 1280:
	set(val):
		space_scale = val
		$bg.adjust_size(val)
		
		#var s = space_scale / 585.
		#
		#starlayer_1.amount = 50 * s
		#starlayer_2.amount = 32 * s
		#starlayer_3.amount = 22 * s
		#starlayer_4.amount = 15 * s
		#
		#starlayer_1.emission_rect_extents.x = 292.5 * s
		#starlayer_2.emission_rect_extents.x = 292.5 * s
		#starlayer_3.emission_rect_extents.x = 292.5 * s
		#starlayer_4.emission_rect_extents.x = 292.5 * s

var paused = true

# Spawn Scaling ====================================================================================

@onready var meteor_spawner: Node2D = $MeteorSpawner
@onready var enemy_spawner: Node2D = $EnemySpawner
@onready var enemies: Node = $Enemies
@onready var meteors: Node = $Meteors
@onready var projectiles: Node = $Projectiles
@onready var particles: Node = $Particles
@onready var player_scene = preload("res://01_Source/03_Space/01_Player/player_space.tscn")

var player: SpacePlayer

func _ready() -> void:
	space_scale = 1280
	
	var s = space_scale / 585.
	
	starlayer_1.amount = 50 * s
	starlayer_2.amount = 32 * s
	starlayer_3.amount = 22 * s
	starlayer_4.amount = 15 * s
	
	starlayer_1.emission_rect_extents.x = 292.5 * s
	starlayer_2.emission_rect_extents.x = 292.5 * s
	starlayer_3.emission_rect_extents.x = 292.5 * s
	starlayer_4.emission_rect_extents.x = 292.5 * s
	
	
	meteor_spawner.meteors = meteors
	meteor_spawner.particles = particles
	enemy_spawner.enemies = enemies
	enemy_spawner.projectiles = projectiles
	enemy_spawner.particles = particles

func start_level() -> void:
	player = player_scene.instantiate()
	add_child(player)
	player.global_position = Vector2(640, 590)
	player.projectiles = projectiles
	paused = false

func handle_mouse(local_mouse_pos: Vector2, is_click: bool, is_held: bool) -> void:
	if is_held:
		Data.custom_mouse.cursor_type = Mouse.AIM
	else:
		Data.custom_mouse.cursor_type = Mouse.AIM2
	
	player.handle_mouse(local_mouse_pos, is_click, is_held)
