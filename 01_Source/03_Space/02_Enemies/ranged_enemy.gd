extends Enemy

# Movement =========================================================================================
var oval_radius: Vector2 = Vector2(75, 0) # 75, 40
var current_angle: float = 0
var fully_spawned: bool = true

# Weapon stuff =====================================================================================
var shooting_time: float = 3
var shooting_timer: float = 3

@onready var movement_point: Node2D = $MovementPoint
@onready var hitbox: CollisionShape2D = $Hitbox
@onready var hurtbox: CollisionShape2D = $Hurtbox.get_node("CollisionShape2D")
@onready var sprite: Sprite2D = $Sprite2D
@onready var gun: Node2D = $Gun

func _ready() -> void:
	type = 1
	hp = 4
	global_position.x += 200
	pass

func _physics_process(delta: float) -> void:
	if !fully_spawned:
		return
	current_angle += TAU/2. * delta
	current_angle = fmod(current_angle, TAU)
	update_position()
	
	shooting_timer -= delta
	if shooting_timer <= 0:
		gun.shoot()
		shooting_timer = shooting_time
	pass

func update_position() -> void:
	var offset: Vector2 = oval_radius.rotated(current_angle)
	offset.y *= 40./75.
	hitbox.position = offset
	hurtbox.position = offset
	sprite.position = offset
	gun.position = offset
	return

func _on_area_entered(area) -> void:
	super._on_area_entered(area)
	pass
