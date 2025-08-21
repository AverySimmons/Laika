extends Obstacle

func _ready() -> void:
	super._ready()
	hp = 2
	velocity = determine_velocity()
	radius = randf_range(40, 60)
	hitbox.shape.radius = radius
	hurtbox.shape.radius = radius
	# Change sprite scale too
	pass

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	pass

func _on_area_entered(area) -> void:
	super._on_area_entered(area)
	# Explosion animation? that ends with queue freeing
	queue_free()
	pass

func determine_velocity() -> Vector2:
	var player_pos: Vector2 = Data.space_player.global_position
	var vector_to_player: Vector2 = (player_pos - global_position) \
									+ Vector2(randf_range(-50, 50), randf_range(-50, 50))
	vector_to_player = vector_to_player.normalized() * randf_range(700, 900)
	return vector_to_player
