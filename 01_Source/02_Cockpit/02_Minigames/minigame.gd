class_name Minigame
extends Node2D

signal success()

@onready var _letter_lock_scene = preload("res://01_Source/02_Cockpit/02_Minigames/00_Letters/letter_lock.tscn")

var _locks = 0

func _spawn_letter_lock(letters: String) -> void:
	var new_letter_lock: LetterLock = _letter_lock_scene.instantiate()
	new_letter_lock.letters = letters
	new_letter_lock.global_position = Data.LIVING_SPACE_SIZE / 2.
	new_letter_lock.success.connect(_open_lock)
	add_child(new_letter_lock)

func _open_lock() -> void:
	_locks -= 1
	if _locks == 0:
		_win()

func _win() -> void:
	pass

func handle_mouse(local_mouse_pos, is_click, is_held) -> void:
	pass
