extends Obstacle

func _ready() -> void:
	super._ready()
	hp = 2
	velocity = determine_velocity()
	radius = randf_range(20, 25)
	hitbox.shape.radius = radius
	hurtbox.shape.radius = radius
	sprite.scale = Vector2(radius/40., radius/40.)
	trail.change_lifetime(0.6)
	trail.change_color(Color("ff52f1"))
	explosion_color = Color("ff40cf")
	lt = 0.75
	explosion_amt = 30
	sprite.rotation = randf_range(0, TAU)
	pass

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	sprite.rotate(delta * PI / 5.)
	pass

func _on_area_entered(area) -> void:
	super._on_area_entered(area)
	die()
	pass

func determine_velocity() -> Vector2:
	var player_pos: Vector2 = Data.space_player.global_position
	var vector_to_player: Vector2 = (player_pos - global_position) \
									+ Vector2(randf_range(-50, 50), randf_range(-50, 50))
	vector_to_player = vector_to_player.normalized() * randf_range(175, 200)
	return vector_to_player
