class_name Minigame
extends Node2D

signal success()

@onready var _letter_scene = preload("res://01_Source/02_Cockpit/02_Minigames/00_Letters/task_letter.tscn")

var _locks = 0
var _letter_queue = []
var _current_letter: TaskLetter
var _letter_timer = 0

func _process(delta: float) -> void:
	_letter_timer -= delta

func _input(event: InputEvent) -> void:
	
	## need to make sure that holding it down doesnt work
	if _letter_queue and _letter_queue[0] == event.as_text() \
			and event.is_pressed() and not event.is_echo() and _letter_timer <= 0:
		
		_letter_queue.pop_front()
		_despawn_letter()
		if _letter_queue:
			_spawn_letter()
		else:
			_open_lock()

func _spawn_letter() -> void:
	_current_letter = _letter_scene.instantiate()
	_current_letter.global_position = Data.LIVING_SPACE_SIZE / 2.
	_current_letter.letter = _letter_queue[0]
	add_child(_current_letter)
	
	_letter_timer = 0.01

func _despawn_letter() -> void:
	_current_letter.despawn()

func _open_lock() -> void:
	_locks -= 1
	if _locks <= 0:
		success.emit()

func _extend_letter_queue(val: String) -> void:
	for i in val:
		if i == "_":
			_letter_queue.push_back("Space")
		else:
			_letter_queue.push_back(str(i))

func handle_mouse(local_mouse_pos, is_click, is_held) -> void:
	pass
