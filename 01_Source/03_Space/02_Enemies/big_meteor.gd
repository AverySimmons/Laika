extends Obstacle

func _ready() -> void:
	hp = 10
	velocity = Vector2(0, randf_range(125, 175))
	radius = randf_range(130, 180)
	pass
