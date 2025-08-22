extends Minigame

const _BALL_RADIUS = 63
const _MOUSE_AVERAGE_COUNT = 30

@onready var _balls = [$TennisBalls/TennisBall, $TennisBalls/TennisBall2, $TennisBalls/TennisBall3]
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var fade_player: AnimationPlayer = $FadePlayer

var _current_ball: Area2D
var _balls_left = 3
var _mouse_offset = Vector2.ZERO

func _init() -> void:
	_locks = 2

func _ready() -> void:
	for ball in _balls:
		ball.out_of_bounds.connect(_ball_thrown)

func _process(delta: float) -> void:
	handle_mouse(get_global_mouse_position(), Input.is_action_just_pressed("click"), Input.is_action_pressed("click"))
	
	if not _current_ball: return
	
	

func _ball_thrown() -> void:
	_balls_left -= 1
	if _balls_left == 0:
		_spawn_letter_lock("FETCH!")
		_open_lock()
		
		var t = create_tween()
		t.tween_property($ThrowLabel, "modulate:a", 0., 0.2)

func _win() -> void:
	animation_player.play("run_away")
	await animation_player.animation_finished
	
	fade_player.play("exit")
	await fade_player.animation_finished
	
	success.emit()
	queue_free()

func handle_mouse(local_mouse_pos, is_click, is_held) -> void:
	
	if _locks != 2: return
	
	if _current_ball:
		if not is_held:
			_current_ball.vel = Input.get_last_mouse_velocity()
			
			_current_ball = null
		
		else:
			_current_ball.global_position = local_mouse_pos + _mouse_offset
			_current_ball.vel = Vector2.ZERO
		return
	
	for ball in _balls:
		if not is_instance_valid(ball): continue
		
		if local_mouse_pos.distance_to(ball.global_position) > _BALL_RADIUS:
			continue
		
		if is_click:
			_current_ball = ball
			_mouse_offset = ball.global_position - local_mouse_pos
