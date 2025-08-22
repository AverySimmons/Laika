extends Obstacle

func _ready() -> void:
	super._ready()
	hp = 10
	velocity = Vector2(0, randf_range(75, 110))
	radius = randf_range(60, 90)
	hitbox.shape.radius = radius
	hurtbox.shape.radius = radius
	sprite.scale = Vector2(radius/100., radius/100.)
	pass

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	pass

func _on_area_entered(area) -> void:
	super._on_area_entered(area)
	pass
