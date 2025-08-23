extends Node2D

@onready var particles: CPUParticles2D = $CPUParticles2D

func _ready() -> void:
	particles.emitting = false
	pass

func explode() -> void:
	particles.emitting = true
	await get_tree().create_timer(particles.lifetime).timeout
	queue_free()
