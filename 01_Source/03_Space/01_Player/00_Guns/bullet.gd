extends Area2D

var speed: float = 1250
var velocity: Vector2
var lifetime: float = 5
var life_timer: float = 0

func _physics_process(delta: float) -> void:
	global_position +=  velocity * delta
	
	life_timer += delta
	if life_timer >= lifetime:
		despawn()
	pass

func shoot(position: Vector2) -> void:
	velocity = speed * position
	pass

func _on_area_entered(area) -> void:
	var obstacle = area.owner
	if obstacle is Obstacle:
		obstacle.take_damage(1)
		despawn()
	pass

func despawn() -> void:
	queue_free()
	pass
