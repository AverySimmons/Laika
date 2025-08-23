extends Area2D

var speed: float = 600
var velocity: Vector2

var mid = Vector2(640,360)
@onready var bounds: Rect2 = Rect2(mid-Data.SPACE_SIZE/2, mid+Data.SPACE_SIZE/2)
var sprite_offset: Vector2

@onready var player: SpacePlayer = Data.space_player
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	connect("area_entered", Callable(self, "_on_area_entered"))
	pass

func _physics_process(delta: float) -> void:
	global_position +=  velocity * delta
	
	if !bounds.has_point(global_position):
		despawn()
	
	if !animation_player.is_playing():
		animation_player.play("move")
	pass

func shoot(direction: Vector2) -> void:
	velocity = direction.normalized() * speed
	pass

func _on_area_entered(area) -> void:
	var player = area.owner
	if player is SpacePlayer:
		player.take_damage()
		despawn()
	pass

func despawn() -> void:
	queue_free()
	pass
