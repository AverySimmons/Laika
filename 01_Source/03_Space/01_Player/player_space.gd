class_name SpacePlayer
extends CharacterBody2D

# HP ===============================================================================================
var max_lives: int = 3
var cur_lives: int = 3

# Movement Variables ===============================================================================
var top_speed: Vector2 = Vector2(700, 350)
var acceleration: Vector2 = top_speed / 0.1
var reverse_acceleration: Vector2 = top_speed / 0.03
var idle_friction: Vector2 = top_speed / 0.07
var movement_vector: Vector2 = Vector2.ZERO
var base_velocity: Vector2 = Vector2.ZERO
var sprite_offset: Vector2 = Vector2(47, 65)
var is_moving: bool = false

# Guns =============================================================================================
@onready var left_gun: Node2D = $LeftGun
@onready var right_gun: Node2D = $RightGun
var guns: Array
var projectiles: Node

@onready var bounds: Vector2 = Data.SPACE_SIZE

@onready var hurtbox: Area2D = $Hurtbox

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var trail: Sprite2D = $Trail

func _ready() -> void:
	# Adding all of the guns to guns array
	guns.append(left_gun)
	guns.append(right_gun)
	Data.space_player = self
	pass

func _physics_process(delta: float) -> void:
	# Movement part ================================================================================
	movement_vector = Input.get_vector("left", "right", "up", "down")
	if movement_vector != Vector2.ZERO:
		is_moving = true
		trail.visible = true
		
		if base_velocity.normalized().dot(movement_vector) < 0.:
			base_velocity.x = move_toward(base_velocity.x, movement_vector.x * top_speed.x, reverse_acceleration.x * delta)
			base_velocity.y = move_toward(base_velocity.y, movement_vector.y * top_speed.y, reverse_acceleration.y * delta)
		else: 
			base_velocity.x = move_toward(base_velocity.x, movement_vector.x * top_speed.x, acceleration.x * delta)
			base_velocity.y = move_toward(base_velocity.y, movement_vector.y * top_speed.y, acceleration.y * delta)
	else:
		is_moving = false
		trail.visible = false
		base_velocity.x = move_toward(base_velocity.x, 0, idle_friction.x * delta)
		base_velocity.y = move_toward(base_velocity.y, 0, idle_friction.y * delta)
	global_position += base_velocity * delta
	
	global_position.x = clamp(global_position.x, 0+sprite_offset.x/2., bounds.x-sprite_offset.x/2.)
	global_position.y = clamp(global_position.y, 0+sprite_offset.y/2., bounds.y-sprite_offset.y/2.)
	
	if is_moving == true && !animation_player.is_playing():
		animation_player.play("trail")

func handle_mouse(local_mouse_pos: Vector2, is_click: bool, is_held: bool) -> void:
	if is_held:
		handle_click(local_mouse_pos)
		

func handle_click(pos: Vector2) -> void:
	for gun in guns:
		gun.handle_click(pos, projectiles)
	pass

func take_damage() -> void:
	cur_lives -= 1
	# Explosion animation
	if cur_lives <= 0:
		SignalBus.lose.emit()
	SignalBus.take_damage.emit(cur_lives)
	# Respawning - maybe find a clear spot at the bottom of the map or destroy everything at a set location and place it there
	pass
