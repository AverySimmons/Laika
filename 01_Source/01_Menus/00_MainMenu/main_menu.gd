extends Node2D

signal start_button_pressed()

func _on_start_button_pressed() -> void:
	start_button_pressed.emit()

func _on_start_button_mouse_entered() -> void:
	Data.custom_mouse.cursor_type = Mouse.NORMAL

func _on_start_button_mouse_exited() -> void:
	Data.custom_mouse.cursor_type = Mouse.INTERACT
