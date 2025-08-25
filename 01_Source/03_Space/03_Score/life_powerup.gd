extends Area2D

func _process(delta: float) -> void:
	position.y += delta * 80
	if position.y > 900: queue_free()
