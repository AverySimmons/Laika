extends Node2D

@export var size = 1
@export var score = 0
@export var scaling = 1

@onready var label: RichTextLabel = $LabelOffset/Label

func _ready() -> void:
	label.text = "[shake level=15]+ " + str(int(score))
	$LabelOffset.modulate = Color.from_hsv(randf_range(275, 330) / 359., 1., 1.)
	
	await $AnimationPlayer.animation_finished
	queue_free()

func _process(delta: float) -> void:
	label.scale = Vector2.ONE * scaling * size
	label.position = -label.size * label.scale / 2. - Vector2(14, 0) * label.scale.x
