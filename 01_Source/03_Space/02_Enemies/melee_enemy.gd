extends Enemy

var top_speed: Vector2 = Vector2(300, 450)
var acceleration: Vector2 = Vector2(150, 225)
var cur_velocity: Vector2

@onready var player: SpacePlayer = Data.space_player


func _ready() -> void:
	hp = 6
	type = 0
	pass

func _physics_process(delta: float) -> void:
	var dir_to_player = player.global_position - global_position
	cur_velocity += dir_to_player*acceleration*delta
	cur_velocity.clamp(-top_speed, top_speed)
	rotation = 3*TAU/4. + cur_velocity.angle()
	global_position += cur_velocity*delta
	pass

func _on_area_entered(area) -> void:
	super._on_area_entered(area)
	# Explosion effect?
	queue_free()
	pass
