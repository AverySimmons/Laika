extends Node2D

signal minigame_complete()

const _LAIKA_CLICK_RADIUS = 50

@onready var laika: Laika = $Laika

var in_minigame = false
var laika_blocking = false

var _minigame_scene: PackedScene
var _current_minigame: Minigame

func _ready() -> void:
	_connect_signals()

func _connect_signals() -> void:
	laika.blocking.connect(_set_minigame)

func _set_minigame(minigame: PackedScene) -> void:
	_minigame_scene = minigame
	laika_blocking = true

func _enter_minigame() -> void:
	_current_minigame = _minigame_scene.instantiate()
	_current_minigame.success.connect(_exit_minigame)
	add_child(_current_minigame)
	
	var t = create_tween()
	t.tween_property(laika, "modulate:a", 0, 0.1)

func _exit_minigame() -> void:
	laika.minigame_complete()
	in_minigame = false
	laika_blocking = false
	
	var t = create_tween()
	t.tween_property(laika, "modulate:a", 1, 0.1)

func handle_mouse(mouse_position, is_click, is_held) -> void:
	if is_held:
		Data.custom_mouse.cursor_type = Mouse.GRAB
	else:
		Data.custom_mouse.cursor_type = Mouse.INTERACT
	
	if in_minigame:
		_current_minigame.handle_mouse(mouse_position, is_click, is_held)
	
	else:
		var laika_dist = mouse_position.distance_to(laika.global_position)
		var overlapping_laika = laika_dist < _LAIKA_CLICK_RADIUS
		
		if overlapping_laika and laika_blocking:
			if is_click:
				in_minigame = true
				_enter_minigame()
			else:
				Data.custom_mouse.cursor_type = Mouse.NORMAL
	
	
