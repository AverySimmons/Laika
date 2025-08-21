extends Node2D

signal settings_closed()

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var _mouse_type

func _ready() -> void:
	_mouse_type = Data.custom_mouse.cursor_type
	Data.custom_mouse.cursor_type = Mouse.INTERACT

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("settings"):
		_close()

func _close() -> void:
	animation_player.play("exit")
	await animation_player.animation_finished
	Data.custom_mouse.cursor_type = _mouse_type
	settings_closed.emit()
	queue_free()
