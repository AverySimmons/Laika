class_name Enemy
extends Area2D

var hp: int
var type: int
var projectiles: Node
var particles: Node
var sprite: Sprite2D

@onready var thruster_trail_scene: PackedScene = preload("res://00_Assets/03_ParticleEffects/thrusters.tscn")
@onready var death_explosion_scene: PackedScene = preload("res://00_Assets/03_ParticleEffects/ship_explosion.tscn")
var thruster_trail: Node2D
var death_explosion: Node2D

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
	modulate = Color(1, 0.5, 0.5)
	await get_tree().create_timer(0.1).timeout
	modulate = Color(1, 1, 1)
	pass

func die() -> void:
	thruster_trail.stop()
	death_explosion = death_explosion_scene.instantiate()
	death_explosion.global_position = sprite.global_position
	particles.add_child(death_explosion)
	death_explosion.explode()
	queue_free()
	pass
