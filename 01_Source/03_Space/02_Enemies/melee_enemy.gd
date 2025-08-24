extends Enemy

var top_speed: Vector2 = Vector2(50, 50)
var acceleration: Vector2 = Vector2(150, 150)
var cur_velocity: Vector2

@onready var player: SpacePlayer = Data.space_player
@onready var thrusters: Node2D = $Thrusters
@onready var movement: CharacterBody2D = $Movement


func _ready() -> void:
	super._ready()
	hp = 5
	type = 0
	thruster_trail.change_length(0.3)
	sprite = $Sprite2D
	score = 75
	score_size = 1.25
	pass

func _process(delta: float) -> void:
	thruster_trail.change_emission_dir(Vector2(0, -1).rotated(movement.cur_velocity.angle()))
	thruster_trail.global_position = thrusters.global_position
	pass

func _physics_process(delta: float) -> void:
	#if player == null:
		#return
	#var dir_to_player = (player.global_position - global_position).normalized()
	#cur_velocity += dir_to_player*acceleration*delta
	#cur_velocity.clamp(-top_speed, top_speed)
	#global_position += cur_velocity*delta
	
	
	#rotation = 3*TAU/4. + cur_velocity.angle()
	pass

func _on_area_entered(area) -> void:
	super._on_area_entered(area)
	# Explosion effect?
	die()
	pass
