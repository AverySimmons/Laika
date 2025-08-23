class_name SpacePlayer
extends CharacterBody2D

# HP ===============================================================================================
var max_lives: int = 3
var cur_lives: int = 3
var invincible: bool = false

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
var particles: Node

@onready var bounds: Vector2 = Data.SPACE_SIZE

@onready var hurtbox: Area2D = $Hurtbox

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var trail: Sprite2D = $Trail

@onready var sprite: Sprite2D = $Sprite2D

@onready var explosion_scene: PackedScene = preload("res://00_Assets/03_ParticleEffects/ship_explosion.tscn")

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
	
	var mid = Vector2(640,360)
	global_position.x = clamp(global_position.x, mid.x-bounds.x/2.+sprite_offset.x/2., mid.x+bounds.x/2.-sprite_offset.x/2.)
	global_position.y = clamp(global_position.y, mid.y-bounds.y/2.+sprite_offset.y/2., mid.y+bounds.y/2.-sprite_offset.y/2.)
	
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
	if invincible:
		return
	invincible = true
	cur_lives -= 1
	# Explosion animation
	var explosion: Node2D = explosion_scene.instantiate()
	explosion.global_position = global_position
	particles.add_child(explosion)
	explosion.explode()
	if cur_lives < 0:
		SignalBus.lose.emit()
	SignalBus.take_damage.emit(cur_lives)
	# Respawning - maybe find a clear spot at the bottom of the map or destroy everything at a set location and place it there
	hide()
	hurtbox.collision_layer = 0
	hurtbox.collision_mask = 0
	await get_tree().create_timer(1.0).timeout.connect(respawn)
	pass

func respawn() -> void:
	invincible = true
	global_position = Vector2(640, 590)
	show()
	hurtbox.collision_layer = 8
	hurtbox.collision_mask = 4
	
	for i in range(7):
		sprite.modulate.a = 0.2
		await get_tree().create_timer(0.2, false).timeout
		sprite.modulate.a = 1.0
		await get_tree().create_timer(0.2, false).timeout
	invincible = false
	pass
