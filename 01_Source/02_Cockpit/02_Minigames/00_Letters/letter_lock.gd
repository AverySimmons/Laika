class_name LetterLock
extends Node2D

signal success()

@onready var label: RichTextLabel = $Label
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var letters: String

var _letter_queue = []
var _frame_used = false
var _spaces = 0

func _ready() -> void:
	for l in letters:
		if l != ' ':
			_letter_queue.push_back(str(l))
		else:
			_spaces += 1
	
	_update_text()

func _process(delta: float) -> void:
	_frame_used = false

func _input(event: InputEvent) -> void:
	if _frame_used: return
	if not _letter_queue: return
	
	var correct_input = (event.as_text() == _letter_queue[0] or \
		event.as_text() == "Shift+"+_letter_queue[0]) or \
		(_letter_queue[0] == '!' and event.as_text() == "Shift+1")
	
	if correct_input and not event.is_released() \
			and not event.is_echo():
		_progress_queue()
		
		if not _letter_queue:
			_complete()

func _update_text() -> void:
	var new_text = "[color=#ffc0ffc0]"
	var ind = letters.length() - _letter_queue.size() - _spaces
	var close_shake = false
	for l in letters:
		if l == ' ':
			new_text += l
			continue
		
		if ind == 0:
			new_text += "[/color]"
			new_text += "[shake rate=25.0 level=40 connected=0]"
			close_shake = true
		
		new_text += l
		
		if close_shake:
			new_text += "[/shake]"
			close_shake = false
		
		ind -= 1
	
	label.text = new_text

func _progress_queue() -> void:
	_letter_queue.pop_front()
	_frame_used = true
	
	_update_text()

func _complete() -> void:
	animation_player.play("Exit")
	await animation_player.animation_finished
	success.emit()
	queue_free()
