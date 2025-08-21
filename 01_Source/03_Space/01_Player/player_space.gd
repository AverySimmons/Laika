extends CharacterBody2D

# HP ===============================================================================================
var max_lives: int = 3
var cur_lives: int = 3

# Movement Variables ===============================================================================
var top_speed: Vector2 = Vector2(500, 250)
var acceleration: Vector2 = top_speed / 0.1
var reverse_acceleration: Vector2 = top_speed / 0.03
var idle_friction: Vector2 = top_speed / 0.07
var movement_vector: Vector2 = Vector2.ZERO
var base_velocity: Vector2 = Vector2.ZERO
@onready var bounds: Vector2 = Data.SPACE_SIZE

# Guns =============================================================================================
@onready var left_gun: Node2D = $LeftGun
@onready var right_gun: Node2D = $RightGun
var guns: Array

func _ready() -> void:
	# Adding all of the guns to guns array
	guns.append(left_gun)
	guns.append(right_gun)
	pass

func _physics_process(delta: float) -> void:
	# Movement part ================================================================================
	movement_vector = Input.get_vector("left", "right", "up", "down")
	if movement_vector != Vector2.ZERO:
		if base_velocity.normalized().dot(movement_vector) < 0.:
			base_velocity.x = move_toward(base_velocity.x, movement_vector.x * top_speed.x, reverse_acceleration.x * delta)
			base_velocity.y = move_toward(base_velocity.y, movement_vector.y * top_speed.y, reverse_acceleration.y * delta)
		else: 
			base_velocity.x = move_toward(base_velocity.x, movement_vector.x * top_speed.x, acceleration.x * delta)
			base_velocity.y = move_toward(base_velocity.y, movement_vector.y * top_speed.y, acceleration.y * delta)
	else:
		base_velocity.x = move_toward(base_velocity.x, 0, idle_friction.x * delta)
		base_velocity.y = move_toward(base_velocity.y, 0, idle_friction.y * delta)
	global_position += base_velocity * delta
	
	global_position.x = clamp(global_position.x, 0, 585)
	global_position.y = clamp(global_position.y, 0, 720)
	pass

func handle_click(position: Vector2) -> void:
	for gun in guns:
		gun.handle_click(position)
	pass

func take_damage() -> void:
	cur_lives -= 1 
	pass
