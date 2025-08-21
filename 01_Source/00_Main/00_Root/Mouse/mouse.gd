class_name Mouse
extends Node

enum {MENU, COCKPIT, COCKPIT_HOVER, SPACE}

var _timer: float = 0
var _cursor_type: int = MENU
var _speed: float = 1
var _last_cursor_image: Image

func _process(delta: float) -> void:
	_set_cursor()
	
	_timer += delta * _speed

func set_type(type) -> void:
	match type:
		MENU:
			print("MENU")
		COCKPIT:
			print("COCKPIT")
		SPACE:
			print("SPACE")

func _set_to_menu() -> void:
	_cursor_type = MENU
	_speed = 1

func _set_to_cockpit() -> void:
	_cursor_type = COCKPIT
	_speed = 1.25

func _set_to_cockpit_hover() -> void:
	_cursor_type = COCKPIT_HOVER
	_speed = 1.25

func _set_to_space() -> void:
	_cursor_type = SPACE
	_speed = 2

func _set_cursor() -> void:
	var cursor_image: Image
	match _cursor_type:
		MENU:
			if _timer > 0.5:
				pass
			else:
				pass
		COCKPIT:
			if _timer > 0.5:
				pass
			else:
				pass
		COCKPIT_HOVER:
			if _timer > 0.5:
				pass
			else:
				pass
		SPACE:
			if _timer > 0.5:
				pass
			else:
				pass
	
	if cursor_image != _last_cursor_image:
		Input.set_custom_mouse_cursor(cursor_image)
		_last_cursor_image = cursor_image
