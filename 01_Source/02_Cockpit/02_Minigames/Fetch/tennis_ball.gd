extends Area2D

signal out_of_bounds()

var vel = Vector2.ZERO

const _BOUNDS_MIN = Vector2(-61,-61)
const _BOUNDS_MAX = Vector2(675, 470) + Vector2(61,61)

func _process(delta: float) -> void:
	global_position += vel * delta
	vel = vel.move_toward(Vector2.ZERO, 100 * delta)
	
	var p = global_position
	if p.x > _BOUNDS_MAX.x or p.x < _BOUNDS_MIN.x \
			or p.y > _BOUNDS_MAX.y or p.y < _BOUNDS_MIN.y:
		out_of_bounds.emit()
		queue_free()
