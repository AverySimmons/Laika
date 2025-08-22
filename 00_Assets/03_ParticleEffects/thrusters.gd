extends Node2D

@onready var particles: CPUParticles2D = $CPUParticles2D

func _ready() -> void:
	particles.emitting = true
	pass

func stop() -> void:
	particles.emitting = false
	await get_tree().create_timer(particles.lifetime).timeout
	queue_free()
	pass

func change_emission_dir(dir: Vector2) -> void:
	particles.direction = dir
	pass

func change_length(length: float) -> void:
	particles.lifetime = length
	pass
