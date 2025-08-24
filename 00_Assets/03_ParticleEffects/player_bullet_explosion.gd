extends CPUParticles2D


func _ready() -> void:
	await get_tree().create_timer(3, false).timeout
	queue_free()
