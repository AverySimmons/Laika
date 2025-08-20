extends Node2D

signal minigame_complete()

const laika_click_radius = 100

@onready var laika: Sprite2D = $Laika

var in_minigame = false
var laika_blocking = false

var _current_minigame

func _ready() -> void:
	_connect_signals()

func _connect_signals() -> void:
	laika.blocking.connect(start_blocking)

func start_blocking() -> void:
	laika_blocking = true

func _handle_click(mouse_position) -> void:
	if in_minigame:
		pass
		# pass click to minigame
	
	else:
		var laika_mouse_dist = mouse_position.distance_to(laika.global_position)
		if laika_mouse_dist < laika_click_radius and laika_blocking:
			in_minigame = true
			# enter minigame
	
	
