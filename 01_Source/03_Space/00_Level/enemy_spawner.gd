extends Node2D

var enemies: Node
var projectiles: Node
var particles: Node

# Wave Spawning ====================================================================================
var wave_size: int = 8
var wave_spawn_time: float = 4
var wave_spawn_timer: float = 0
var time_between_enemies: float = 0.5

@onready var ranged_enemy: PackedScene = preload("res://01_Source/03_Space/02_Enemies/ranged_enemy.tscn")
@onready var melee_enemy: PackedScene = preload("res://01_Source/03_Space/02_Enemies/melee_enemy.tscn")
@onready var enemy_list: Array

func _ready() -> void:
	enemy_list.append(melee_enemy)
	enemy_list.append(ranged_enemy)
	pass

func _physics_process(delta: float) -> void:
	if get_parent().paused: return
	if Data.score >= 10000: return
	
	wave_spawn_timer -= delta
	if wave_spawn_timer <= 0:
		spawn_wave()
	
	wave_spawn_time -= wave_spawn_time * 0.0035 * delta
	pass

func spawn_wave() -> void:
	wave_size = randi_range(1, 3)
	
	wave_spawn_timer = randfn(wave_spawn_time*wave_size, 1.*wave_size)+ time_between_enemies*wave_size
	for num in range(wave_size):
		var enemy_type = randi_range(0, 1)
		var enemy: Enemy = enemy_list[enemy_type].instantiate()
		var location: Vector2 = Vector2(randf_range(437.5, 847.), -50)
		enemy.global_position = location
		enemy.projectiles = projectiles
		enemy.particles = particles
		enemies.add_child(enemy)
		await get_tree().create_timer(time_between_enemies).timeout
		
	pass
