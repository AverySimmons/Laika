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

func change_size(rad: float) -> void:
	particles.emission_sphere_radius = rad
	pass
