extends Minigame

const _HAND_SPEED = 500
const _RETREAT_SPEED = 600

@onready var mouth_marker: Marker2D = $Laika/MouthMarker
@onready var food_marker: Marker2D = $Hand/FoodMarker
@onready var hand: Sprite2D = $Hand
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var fade_player: AnimationPlayer = $FadePlayer

var _times_fed = 0
var _hand_exists = false
var _hand_side = -1

func _init() -> void:
	_locks = 1

func _ready() -> void:
	hand.modulate.a = 0
	
	_spawn_hand()

func _process(delta: float) -> void:
	if not _hand_exists: return
	
	var move_dir = Input.get_vector("arrow_left", "arrow_right", "arrow_up", "arrow_down")
	
	if move_dir != Vector2.ZERO:
		hand.global_position += move_dir * _HAND_SPEED * delta
	
	else:
		match _hand_side:
			0:
				hand.global_position += Vector2(-1, 0) * _RETREAT_SPEED * delta
			1:
				hand.global_position += Vector2(0, 1) * _RETREAT_SPEED * delta
			2:
				hand.global_position += Vector2(1, 0) * _RETREAT_SPEED * delta
	
	var dim = Data.LIVING_SPACE_SIZE
	var hand_pos = hand.global_position
	match _hand_side:
		0:
			hand.global_position = hand_pos.clamp(Vector2(-120,40), Vector2(215,dim.y-40))
		1:
			hand.global_position = hand_pos.clamp(Vector2(40,dim.y-215), Vector2(dim.x-40,dim.y+120))
		2:
			hand.global_position = hand_pos.clamp(Vector2(dim.x-215,40), Vector2(dim.x+120,dim.y-40))
	
	if food_marker.global_position.distance_to(mouth_marker.global_position) < 40:
		_laika_fed()

func _laika_fed() -> void:
	_hand_exists = false
	_times_fed += 1
	$Chomp.play()
	$CPUParticles2D.emitting = true
	
	var t = create_tween()
	t.tween_property(hand, "modulate:a", 0, 0.2)
	
	animation_player.play("eating")
	
	if _times_fed == 3:
		_open_lock()
		return
	
	await t.finished
	await get_tree().create_timer(1).timeout
	
	animation_player.play("start_waiting")
	
	_spawn_hand()

func _spawn_hand() -> void:
	var dim = Data.LIVING_SPACE_SIZE
	if _hand_side >= 0:
		var new_side = randi_range(0, 1)
		if new_side >= _hand_side: new_side += 1
		_hand_side = new_side
	else:
		_hand_side = randi_range(0,2)
	var hand_position
	match _hand_side:
		0:
			hand_position = Vector2(-101+40, randf_range(40, dim.y-40))
			hand.rotation_degrees = 90
		1:
			hand_position = Vector2(randf_range(40, dim.x-40), dim.y+101-40)
			hand.rotation_degrees = 0
		2:
			hand_position = Vector2(dim.x-40+101, randf_range(40, dim.y-40))
			hand.rotation_degrees = -90
		
	hand.global_position = hand_position
	
	var t = create_tween()
	t.tween_property(hand, "modulate:a", 1, 0.4)
	await t.finished
	_hand_exists = true

func _play_waiting_animation() -> void:
	animation_player.play("waiting")

func _win() -> void:
	fade_player.play("exit")
	await fade_player.animation_finished
	success.emit()
	queue_free()

func handle_mouse(local_mouse_pos, is_click, is_held) -> void:
	pass
	
	# dont do anything
