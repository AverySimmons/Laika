extends Node2D

signal minigame_complete()

const laika_click_radius = 100

@onready var laika: Sprite2D = $Laika

var in_minigame = false
var laika_blocking = false
var is_hovering = false

var _current_minigame

func _ready() -> void:
	_connect_signals()

func _connect_signals() -> void:
	laika.blocking.connect(_start_blocking)

func _start_blocking() -> void:
	laika_blocking = true

func handle_mouse(mouse_position, is_click, is_held) -> void:
	if in_minigame:
		pass
		# pass click to minigame
	
	elif is_click and laika_blocking:
		var laika_mouse_dist = mouse_position.distance_to(laika.global_position)
		if laika_mouse_dist < laika_click_radius:
			in_minigame = true
			# enter minigame
