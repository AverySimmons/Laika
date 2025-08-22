class_name Mouse
extends Node

enum {NORMAL, INTERACT, GRAB, AIM}

var cursor_type: int = NORMAL

var _normal_cursor = preload("res://00_Assets/00_Sprites/cursor sprites/hand_cursor_normal.png").get_image()
var _interact_cursor = preload("res://00_Assets/00_Sprites/cursor sprites/hand_cursor_interact.png").get_image()
var _grab_cursor = preload("res://00_Assets/00_Sprites/cursor sprites/hand_cursor_grab.png").get_image()
var _aim1_cursor = preload("res://00_Assets/00_Sprites/cursor sprites/spaceship_aim_cusor_1.png").get_image()
var _aim2_cursor = preload("res://00_Assets/00_Sprites/cursor sprites/spaceship_aim_cusor_2.png").get_image()

var _timer: float = 0
var _last_cursor_image: Image

func _process(delta: float) -> void:
	_set_cursor()
	
	_timer = fmod(_timer + delta * 2., 1.)

func _set_cursor() -> void:
	var cursor_image: Image
	var hotspot: Vector2
	match cursor_type:
		NORMAL:
			cursor_image = _normal_cursor
			hotspot = Vector2(16, 16)
		INTERACT:
			cursor_image = _interact_cursor
			hotspot = Vector2(12, 0)
		GRAB:
			cursor_image = _grab_cursor
			hotspot = Vector2(16, 16)
		AIM:
			if _timer > 0.5:
				cursor_image = _aim1_cursor
			else:
				cursor_image = _aim2_cursor
			hotspot = Vector2(16, 16)
	
	if cursor_image != _last_cursor_image:
		Input.set_custom_mouse_cursor(cursor_image, 0, hotspot)
		_last_cursor_image = cursor_image
