extends CharacterBody2D

var top_speed: Vector2 = Vector2(200, 200)
var acceleration: Vector2 = Vector2(400, 400)
var cur_velocity: Vector2

var initialization_timer: float = 1
var initialized: bool = false

@onready var player: SpacePlayer = Data.space_player
@onready var parent: Area2D = get_parent()

func _physics_process(delta: float) -> void:
	if initialized == false:
		initialization_timer -= delta
		if initialization_timer <= 0:
			initialized = true
			collision_mask = 64 # Same layer as walls
	if player == null:
		return
	var dir_to_player = (player.global_position - global_position).normalized()
	cur_velocity += dir_to_player*acceleration*delta
	#print("Pre:", cur_velocity)
	cur_velocity.x = clamp(cur_velocity.x, -top_speed.x, top_speed.x)
	cur_velocity.y = clamp(cur_velocity.y, -top_speed.y, top_speed.y)
	#print("Post:", cur_velocity)
	var collision = move_and_collide(cur_velocity*delta)
	if collision:
		cur_velocity = cur_velocity.bounce(collision.get_normal())
	
	parent.global_position = global_position
	position = Vector2.ZERO
	parent.rotation = 3*TAU/4. + cur_velocity.angle()
	
	pass
