@tool

extends ColorRect

func _process(_delta):
	material.set_shader_parameter("size", size)

func adjust_size(new_size: float) -> void:
	size.x = new_size
	position.x = 1280./2. - size.x / 2.
	
	for c: CPUParticles2D in get_children():
		c.position = Vector2(size.x / 2., 0)
