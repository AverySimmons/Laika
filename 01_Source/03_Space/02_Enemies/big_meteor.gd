extends Obstacle

func _ready() -> void:
	super._ready()
	hp = 15
	velocity = Vector2(0, 80)
	radius = randf_range(80, 100)
	hitbox.shape.radius = radius
	hurtbox.shape.radius = radius
	sprite.scale = Vector2(radius/173., radius/173.)
	trail.change_size(radius)
	trail.change_lifetime(1.8)
	trail.change_amount(100)
	trail.change_velocity_angle(90)
	trail.change_color(Color("8b47ff"))
	explosion_color = Color("c830cf")
	particle_rad = radius/2.
	sprite.rotation = randf_range(0,TAU)
	pass

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	sprite.rotate(delta * PI / 10.)
	pass

func _on_area_entered(area) -> void:
	super._on_area_entered(area)
	pass
