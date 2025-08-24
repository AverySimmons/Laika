class_name Obstacle
extends Area2D

var radius: float
var hp: int
var velocity: Vector2

var mid = Vector2(640,360)
@onready var bounds: Rect2 = Rect2(mid-Data.SPACE_SIZE/2-Vector2(100, 100), mid+Data.SPACE_SIZE+Vector2(100, 100))
var sprite_offset: Vector2
var despawnable: bool = false
var despawnable_timer: float = 0.5
var particle_rad: float = 4

var explosion_color = Color("white")

@onready var hitbox: CollisionShape2D = $Hitbox
@onready var hurtbox: CollisionShape2D = $Hurtbox.get_node("CollisionShape2D")
@onready var sprite: Node2D = $Sprite2D
var trail: Node2D
var explosion: Node2D
var lt: float = 1.0
var explosion_amt: int = 45
@onready var particles: Node
@onready var trail_scene: PackedScene = preload("res://00_Assets/03_ParticleEffects/rocktrail.tscn")
@onready var explosion_scene: PackedScene = preload("res://00_Assets/03_ParticleEffects/rock_explosion.tscn")

func _ready() -> void:
	connect("area_entered", Callable(self, "_on_area_entered"))
	trail = trail_scene.instantiate()
	particles.add_child(trail)
	trail.global_position = global_position
	pass

func _process(delta: float) -> void:
	trail.global_position = global_position
	pass

func _physics_process(delta: float) -> void:
	global_position += velocity * delta
	if despawnable:
		if !bounds.has_point(global_position):
			trail.stop()
			queue_free()
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
	modulate = Color(3, 1.7, 1.7)
	await get_tree().create_timer(0.1).timeout
	modulate = Color(1, 1, 1)
	pass

func die() -> void:
	trail.stop()
	explosion = explosion_scene.instantiate()
	explosion.global_position = global_position
	particles.add_child(explosion)
	explosion.set_lifetime(lt, explosion_amt)
	explosion.set_color(explosion_color)
	explosion.explode()
	queue_free()
	pass
