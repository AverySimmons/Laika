@tool

extends ColorRect

func _process(_delta):
	material.set_shader_parameter("size", size)
