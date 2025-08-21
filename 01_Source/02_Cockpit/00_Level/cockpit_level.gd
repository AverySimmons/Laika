extends Node2D

signal minigame_complete()

const _LAIKA_CLICK_RADIUS = 100

@onready var laika: Sprite2D = $Laika

var in_minigame = false
var laika_blocking = false

var _current_minigame: Minigame

func _ready() -> void:
	_connect_signals()

func _connect_signals() -> void:
	laika.blocking.connect(_enter_minigame)

func _enter_minigame(minigame: PackedScene) -> void:
	laika_blocking = true
	_current_minigame = minigame.instantiate()
	_current_minigame.success.connect(_exit_minigame)
	add_child(_current_minigame)

func _exit_minigame() -> void:
	pass

func handle_mouse(mouse_position, is_click, is_held) -> void:
	if in_minigame:
		pass
		# pass click to minigame
	
	elif is_click and laika_blocking:
		var laika_mouse_dist = mouse_position.distance_to(laika.global_position)
		if laika_mouse_dist < _LAIKA_CLICK_RADIUS:
			in_minigame = true
			# enter minigame
	
	if is_held:
		Data.custom_mouse.cursor_type = Mouse.GRAB
	else:
		Data.custom_mouse.cursor_type = Mouse.NORMAL
