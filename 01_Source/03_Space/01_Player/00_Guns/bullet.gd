extends Area2D

var speed: float = 1250
var velocity: Vector2

@onready var bounds: Rect2 = Rect2(Vector2.ZERO-sprite_offset/2., Data.SPACE_SIZE+sprite_offset/2.)
var sprite_offset: Vector2 = Vector2(10, 20)

func _physics_process(delta: float) -> void:
	print(bounds)
	global_position +=  velocity * delta
	
	if !bounds.has_point(global_position):
		despawn()
	pass

func shoot(position: Vector2) -> void:
	velocity = speed * position.normalized()
	# Set rotation
	pass

func _on_area_entered(area) -> void:
	var obstacle = area.owner
	if obstacle is Obstacle or obstacle is Enemy:
		obstacle.take_damage(1)
		despawn()
	pass

func despawn() -> void:
	queue_free()
	pass
