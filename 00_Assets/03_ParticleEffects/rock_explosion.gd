extends Node2D

@onready var particles: CPUParticles2D = $CPUParticles2D
@onready var audio: AudioStreamPlayer2D = $Explosion

func _ready() -> void:
	particles.emitting = false
	pass

func explode() -> void:
	particles.emitting = true
	audio.play()
	await get_tree().create_timer(particles.lifetime).timeout
	queue_free()

func set_lifetime(lt: float, amt: int) -> void:
	particles.lifetime = lt
	particles.amount = amt
	pass
