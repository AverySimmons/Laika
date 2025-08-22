class_name Obstacle
extends Area2D

var radius: float
var hp: int
var velocity: Vector2

@onready var bounds: Rect2 = Rect2(Vector2.ZERO+Vector2(-100,-100), Data.SPACE_SIZE+Vector2(300, 300))
var sprite_offset: Vector2
var despawnable: bool = false
var despawnable_timer: float = 0.5
var particle_rad: float = 4

@onready var hitbox: CollisionShape2D = $Hitbox
@onready var hurtbox: CollisionShape2D = $Hurtbox.get_node("CollisionShape2D")
@onready var sprite: Sprite2D = $Sprite2D
var trail: Node2D
@onready var particles: Node
@onready var trail_scene: PackedScene = preload("res://00_Assets/03_ParticleEffects/rocktrail.tscn")

func _ready() -> void:
	connect("area_entered", Callable(self, "_on_area_entered"))
	trail = trail_scene.instantiate()
	particles.add_child(trail)
	trail.global_position = global_position
	pass

func _process(delta: float) -> void:
	trail.global_position = global_position #- Vector2(radius+particle_rad, 0).rotated(velocity.angle())
	pass

func _physics_process(delta: float) -> void:
	global_position += velocity * delta
	if despawnable:
		if !bounds.has_point(global_position):
			die()
	pass

func _on_area_entered(area) -> void:
	var player = area.owner
	if player is SpacePlayer:
		player.take_damage()
	pass


func take_damage(damage: int) -> void:
	hp -= damage
	if hp <= 0:
		die()
	pass

func die() -> void:
	trail.stop()
	queue_free()
	pass
