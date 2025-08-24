class_name SpacePlayer
extends CharacterBody2D

# HP ===============================================================================================
var max_lives: int = 3
var cur_lives: int = 3
var invincible: bool = false

# Movement Variables ===============================================================================
var top_speed: Vector2 = Vector2(350, 200)
var acceleration: Vector2 = top_speed / 0.1
var reverse_acceleration: Vector2 = top_speed / 0.03
var idle_friction: Vector2 = top_speed / 0.07
var movement_vector: Vector2 = Vector2.ZERO
var base_velocity: Vector2 = Vector2.ZERO
var sprite_offset: Vector2 = Vector2(300, 370) * 0.35
var is_moving: bool = false
var is_dead: bool = false

var paused = false

# Guns =============================================================================================
@onready var left_gun: Node2D = $LeftGun
@onready var right_gun: Node2D = $RightGun
var guns: Array
var projectiles: Node
var particles: Node

@onready var bounds: Vector2 = Data.SPACE_SIZE

@onready var hurtbox: Area2D = $Hurtbox

@onready var trail_player: AnimationPlayer = $TrailPlayer

@onready var trail: Sprite2D = $Trail

@onready var sprite: Sprite2D = $Sprite2D

@onready var explosion_scene: PackedScene = preload("res://00_Assets/03_ParticleEffects/ship_explosion.tscn")

func _ready() -> void:
	sprite.material.set_shader_parameter("alpha", 0)
	# Adding all of the guns to guns array
	guns.append(left_gun)
	guns.append(right_gun)
	Data.space_player = self
	pass

func _physics_process(delta: float) -> void:
	if paused: return
	
	# Movement part ================================================================================
	movement_vector = Input.get_vector("left", "right", "up", "down")
	if movement_vector != Vector2.ZERO:
		is_moving = true
		#trail.visible = true
		
		if base_velocity.normalized().dot(movement_vector) < 0.:
			base_velocity.x = move_toward(base_velocity.x, movement_vector.x * top_speed.x, reverse_acceleration.x * delta)
			base_velocity.y = move_toward(base_velocity.y, movement_vector.y * top_speed.y, reverse_acceleration.y * delta)
		else: 
			base_velocity.x = move_toward(base_velocity.x, movement_vector.x * top_speed.x, acceleration.x * delta)
			base_velocity.y = move_toward(base_velocity.y, movement_vector.y * top_speed.y, acceleration.y * delta)
	else:
		is_moving = false
		#trail.visible = false
		base_velocity.x = move_toward(base_velocity.x, 0, idle_friction.x * delta)
		base_velocity.y = move_toward(base_velocity.y, 0, idle_friction.y * delta)
	global_position += base_velocity * delta
	
	var mid = Vector2(640,360)
	global_position.x = clamp(global_position.x, mid.x-bounds.x/2.+sprite_offset.x/2., mid.x+bounds.x/2.-sprite_offset.x/2.)
	global_position.y = clamp(global_position.y, mid.y-bounds.y/2.+sprite_offset.y/2., mid.y+bounds.y/2.-sprite_offset.y/2.)
	
	var speed_amount = (base_velocity / top_speed).length() * (base_velocity.normalized().dot(Vector2.UP) / 2. + 0.5)
	
	trail.scale.y = 0.181 + 0.1 * speed_amount
	trail.position.y = 69 + 13 * speed_amount
	trail_player.speed_scale = 2. + speed_amount * 2.
	$Thrusters.volume_db = -10 + 5 * speed_amount
	$Thrusters.pitch_scale = 3 + 0.5 * speed_amount
	
	#if is_moving == true && !animation_player.is_playing():
		#animation_player.play("trail")

func unpause() -> void:
	paused = false
	create_tween().tween_method(_set_shader_alpha, 0., 1., 0.2)

func _set_shader_alpha(val: float) -> void:
	sprite.material.set_shader_parameter("alpha", val)

func handle_mouse(local_mouse_pos: Vector2, is_click: bool, is_held: bool) -> void:
	if is_held:
		handle_click(local_mouse_pos)
		

func handle_click(pos: Vector2) -> void:
	if is_dead: return
	for gun in guns:
		gun.handle_click(pos, projectiles, particles)
	pass

func take_damage() -> void:
	if invincible:
		return
	invincible = true
	cur_lives -= 1
	is_dead = true
	# Explosion animation
	var explosion: Node2D = explosion_scene.instantiate()
	explosion.global_position = global_position
	particles.add_child(explosion)
	explosion.explode()
	hide()
	hurtbox.collision_layer = 0
	hurtbox.collision_mask = 0
	if cur_lives < 0:
		SignalBus.lose.emit()
		return
	
	# Respawning - maybe find a clear spot at the bottom of the map or destroy everything at a set location and place it there
	await get_tree().create_timer(1.0).timeout.connect(respawn)
	pass

func respawn() -> void:
	SignalBus.change_player_lives.emit(cur_lives)
	$Respawn.play()
	is_dead = false
	invincible = true
	
	global_position = Vector2(640, 590)
	show()
	hurtbox.collision_layer = 8
	hurtbox.collision_mask = 4
	
	for i in range(7):
		modulate.a = 0.2
		sprite.material.set_shader_parameter("alpha", 0.2)
		await get_tree().create_timer(0.2, false).timeout
		modulate.a = 1.0
		sprite.material.set_shader_parameter("alpha", 1.)
		await get_tree().create_timer(0.2, false).timeout
	invincible = false
	
	pass
