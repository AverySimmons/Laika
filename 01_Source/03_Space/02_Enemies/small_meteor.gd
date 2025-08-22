extends Obstacle

func _ready() -> void:
	super._ready()
	hp = 2
	velocity = determine_velocity()
	radius = randf_range(10, 15)
	hitbox.shape.radius = radius
	hurtbox.shape.radius = radius
	sprite.scale = Vector2(radius/40., radius/40.)
	pass

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	pass

func _on_area_entered(area) -> void:
	super._on_area_entered(area)
	die()
	pass

func determine_velocity() -> Vector2:
	var player_pos: Vector2 = Data.space_player.global_position
	var vector_to_player: Vector2 = (player_pos - global_position) \
									+ Vector2(randf_range(-50, 50), randf_range(-50, 50))
	vector_to_player = vector_to_player.normalized() * randf_range(400, 600)
	return vector_to_player
