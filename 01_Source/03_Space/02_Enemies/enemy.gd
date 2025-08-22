class_name Enemy
extends Area2D

var hp: int
var type: int
var projectiles: Node

func _ready() -> void:
	connect("area_entered", Callable(self, "_on_area_entered"))
	pass

func _on_area_entered(area) -> void:
	var player = area.owner
	if player is SpacePlayer:
		player.take_damage()
	pass

func take_damage(damage: int) -> void:
	hp -= damage
	if hp <= 0:
		die()
	pass

func die() -> void:
	queue_free()
	pass
