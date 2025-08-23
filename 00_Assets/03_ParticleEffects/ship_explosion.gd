extends Node2D

@onready var particles: CPUParticles2D = $CPUParticles2D
@onready var audio: AudioStreamPlayer = $Explosion

func _ready() -> void:
	particles.emitting = false
	pass

func explode() -> void:
	particles.emitting = true
	audio.play()
	await get_tree().create_timer(particles.lifetime).timeout
	queue_free()
