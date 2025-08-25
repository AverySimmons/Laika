extends Node2D

@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D

func _ready() -> void:
	cpu_particles_2d.emitting = true
	await get_tree().create_timer(3).timeout
	queue_free()
