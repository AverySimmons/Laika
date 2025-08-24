extends Area2D

var speed: float = 2000
var velocity: Vector2

var explosion_scene = preload("res://00_Assets/03_ParticleEffects/player_bullet_explosion.tscn")

var mid = Vector2(640,360)
@onready var bounds: Rect2 = Rect2(mid-Data.SPACE_SIZE/2-Vector2.ONE*50, mid+Data.SPACE_SIZE+Vector2.ONE*50)
var sprite_offset: Vector2 = Vector2(10, 20)
@onready var ap: AnimationPlayer = $AnimationPlayer

var particles: Node

func _ready() -> void:
	connect("area_entered", Callable(self, "_on_area_entered"))
	pass

func _physics_process(delta: float) -> void:
	global_position +=  velocity * delta
	
	if !bounds.has_point(global_position):
		despawn()
	
	
	pass

func shoot(position: Vector2) -> void:
	velocity = speed * global_position.direction_to(position).normalized()
	rotation = velocity.angle() + TAU/4.
	pass

func _on_area_entered(area) -> void:
	var obstacle = area.owner
	if obstacle is Obstacle or obstacle is Enemy:
		obstacle.take_damage(1)
		explode()
	pass

func explode() -> void:
	var explosion = explosion_scene.instantiate()
	explosion.global_position = global_position
	particles.add_child(explosion)
	explosion.emitting = true
	queue_free()

func despawn() -> void:
	queue_free()
	pass
