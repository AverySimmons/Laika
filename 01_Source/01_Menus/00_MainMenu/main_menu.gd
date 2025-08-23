extends Node2D

signal start_button_pressed()

@onready var title_screen_button_spritesheet: Sprite2D = $TitleScreenButtonSpritesheet
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var _exiting = false

func _on_start_button_pressed() -> void:
	if _exiting: return
	_exiting = true
	
	$Click.play()
	
	animation_player.play("exit")
	await animation_player.animation_finished
	
	start_button_pressed.emit()

func _on_start_button_mouse_entered() -> void:
	if _exiting: return
	
	Data.custom_mouse.cursor_type = Mouse.NORMAL
	title_screen_button_spritesheet.modulate = Color("ffa0e0")
	$Hover.play()

func _on_start_button_mouse_exited() -> void:
	if _exiting: return
	
	Data.custom_mouse.cursor_type = Mouse.INTERACT
	title_screen_button_spritesheet.modulate = Color("ffffff")
