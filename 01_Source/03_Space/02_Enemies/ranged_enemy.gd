extends Enemy

# Movement =========================================================================================
var oval_radius: Vector2 = Vector2(75, 0) # 75, 40
var current_angle: float = 0

# Weapon stuff =====================================================================================
var shooting_time: float = 6
var shooting_timer: float = randfn(shooting_time, 2.)

@onready var movement_point: Node2D = $MovementPoint
@onready var hitbox: CollisionShape2D = $Hitbox
@onready var hurtbox: CollisionShape2D = $Hurtbox.get_node("CollisionShape2D")
@onready var gun: Node2D = $Gun
@onready var thrusters: Node2D = $Thruster

func _ready() -> void:
	super._ready()
	type = 1
	hp = 3
	sprite = $Sprite2D
	score = 125
	score_size = 1.5
	pass

func _physics_process(delta: float) -> void:
	current_angle += TAU/2. * delta
	current_angle = fmod(current_angle, TAU)
	update_position()
	
	shooting_timer -= delta
	if shooting_timer <= 0:
		gun.shoot(projectiles)
		shooting_timer = randfn(shooting_time, 2.)
	pass

func _process(delta: float) -> void:
	thruster_trail.global_position = thrusters.global_position
	pass

func update_position() -> void:
	var offset: Vector2 = oval_radius.rotated(current_angle)
	offset.y *= 40./75.
	hitbox.position = offset
	hurtbox.position = offset
	sprite.position = offset
	gun.position = offset
	thrusters.position = offset + Vector2(0, -35)
	return

func _on_area_entered(area) -> void:
	super._on_area_entered(area)
	pass
