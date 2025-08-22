class_name Enemy
extends Area2D

var hp: int
var type: int
var projectiles: Node
var particles: Node

@onready var thruster_trail_scene: PackedScene = preload("res://00_Assets/03_ParticleEffects/thrusters.tscn")
var thruster_trail: Node2D

func _ready() -> void:
	connect("area_entered", Callable(self, "_on_area_entered"))
	thruster_trail = thruster_trail_scene.instantiate()
	particles.add_child(thruster_trail)
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
	thruster_trail.stop()
	queue_free()
	pass
