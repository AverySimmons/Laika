extends Obstacle

func _ready() -> void:
	super._ready()
	hp = 10
	velocity = Vector2(0, randf_range(75, 110))
	radius = randf_range(60, 90)
	hitbox.shape.radius = radius
	hurtbox.shape.radius = radius
	sprite.scale = Vector2(radius/173., radius/173.)
	trail.change_size(radius)
	trail.change_lifetime(1.8)
	particle_rad = radius/2.
	pass

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	pass

func _on_area_entered(area) -> void:
	super._on_area_entered(area)
	pass
