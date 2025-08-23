extends Node2D

var meteors: Node
var particles: Node
# Small Meteor Spawning ============================================================================
var small_meteor_spawn_speed: float = 1.0
var small_meteor_spawn_timer: float = 1.0
var small_meteor_spawn_point: float = 785

# Large Meteor Spawning ============================================================================
var large_meteor_spawn_speed: float = 5
var large_meteor_spawn_timer: float = 5
var large_meteor_spawn_point: float = 585

@onready var small_meteor_scene: PackedScene = preload("res://01_Source/03_Space/02_Enemies/small_meteor.tscn")
@onready var large_meteor_scene: PackedScene = preload("res://01_Source/03_Space/02_Enemies/big_meteor.tscn")

func _physics_process(delta: float) -> void:
	if get_parent().paused: return
	
	small_meteor_spawn_timer -= delta
	if small_meteor_spawn_timer <= 0:
		spawn_small_meteor()
	
	large_meteor_spawn_timer -= delta
	if large_meteor_spawn_timer <= 0:
		spawn_big_meteor()
	pass

func spawn_small_meteor() -> void:
	small_meteor_spawn_timer = small_meteor_spawn_speed
	var spawn_point_x: float = randf_range(0, 785)
	var spawn_point_y: float = 0
	if spawn_point_x < 100:
		spawn_point_y += 100-spawn_point_x
		spawn_point_x = 0
	var spawn_point: Vector2 = Vector2(spawn_point_x+347.5, spawn_point_y)
	var meteor: Obstacle = small_meteor_scene.instantiate()
	meteor.global_position = spawn_point
	meteor.particles = particles
	meteors.add_child(meteor)
	meteor.despawnable = true
	pass
var mid = Vector2(640, 585)
func spawn_big_meteor() -> void:
	large_meteor_spawn_timer = large_meteor_spawn_speed
	var spawn_point: Vector2 = Vector2(randf_range(347.5, 932.5), 0)
	var meteor: Obstacle = large_meteor_scene.instantiate()
	meteor.global_position = spawn_point
	meteor.particles = particles
	meteors.add_child(meteor)
	meteor.despawnable = true
	pass
	
