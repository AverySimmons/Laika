class_name TaskLetter
extends Node2D

@onready var label: Label = $Label
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var letter: String

func _ready() -> void:
	label.text = letter

func despawn() -> void:
	animation_player.play("Exit")
	await animation_player.animation_finished
	queue_free()
