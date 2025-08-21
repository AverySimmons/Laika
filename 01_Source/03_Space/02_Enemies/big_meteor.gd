extends Obstacle

func _ready() -> void:
	super._ready()
	hp = 10
	velocity = Vector2(0, randf_range(125, 175))
	radius = randf_range(130, 180)
	hitbox.shape.radius = radius
	hurtbox.shape.radius = radius
	# Change sprite scale too
	pass

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	pass

func _on_area_entered(area) -> void:
	super._on_area_entered(area)
	pass
