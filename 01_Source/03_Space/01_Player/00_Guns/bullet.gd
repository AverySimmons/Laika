extends Area2D

var speed: float = 1750
var velocity: Vector2

@onready var bounds: Rect2 = Rect2(Vector2.ZERO-sprite_offset/2., Data.SPACE_SIZE+sprite_offset/2.)
var sprite_offset: Vector2 = Vector2(10, 20)
@onready var ap: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	connect("area_entered", Callable(self, "_on_area_entered"))
	pass

func _physics_process(delta: float) -> void:
	global_position +=  velocity * delta
	
	if !bounds.has_point(global_position):
		despawn()
	
	if !ap.is_playing():
		ap.play("move")
	
	pass

func shoot(position: Vector2) -> void:
	velocity = speed * global_position.direction_to(position).normalized()
	rotation = velocity.angle() + TAU/4.
	pass

func _on_area_entered(area) -> void:
	var obstacle = area.owner
	print(obstacle)
	if obstacle is Obstacle or obstacle is Enemy:
		print("yes")
		obstacle.take_damage(1)
		despawn()
	pass

func despawn() -> void:
	queue_free()
	pass
