class_name Laika
extends Node2D

signal blocking(minigame: PackedScene)

## IDLE: pick a location, walk there, sit for a little, repeat
## RUNNING: run to chosen task
## BLOCKING: block at chosen task until clicked

enum {IDLE, RUNNING, BLOCKING, SLEEPING}

const _TASKS: Dictionary[PackedScene, Vector2] = {
	preload("res://01_Source/02_Cockpit/02_Minigames/Pet/pet_minigame.tscn") : Vector2(50,50),
}

const _IDLE_SPEED = 20
const _RUNNING_SPEED = 30
const _NEW_TASK_TIME_RANGE = Vector2(13, 17)
const _IDLE_TIME_RANGE = Vector2(5, 8)
const _GLOBAL_SIZE = Vector2(480, 190)
const _LOCAL_SIZE = Vector2(100, 100)
const _TO_LOCAL_X_DIF = 240
const _BASE_SPRITE_HEIGHT = 100
const _SPRITE_RESCALE = Vector2(1.3,1.3)
const _ANCHOR_POINT_GLOBAL = Vector2(90, 460)

const _SLEEP_POSITION = Vector2(26,90)
const _SLEEP_TIME_RANGE = Vector2(10, 12)
const _SLEEP_COOLDOWN_RANGE = Vector2(30, 40)

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D

var _local_position = Vector2(50,50)
var _state = IDLE
var _current_task: PackedScene
var _new_task_timer = 15

var _idle_timer = 0
var _idle_is_moving = false
var _idle_target_position = Vector2.ZERO

var _sleep_timer = 0
var _sleep_cooldown_timer = 0

func minigame_complete() -> void:
	_state = IDLE
	_enter_idle()
	_new_task_timer = randf_range(_NEW_TASK_TIME_RANGE.x, _NEW_TASK_TIME_RANGE.y)

func _ready() -> void:
	_enter_idle()

func _process(delta: float) -> void:
	match _state:
		IDLE:
			_process_idle(delta)
		RUNNING:
			_process_running(delta)
		BLOCKING:
			_process_blocking(delta)
		SLEEPING:
			_process_sleeping(delta)
	
	_update_sprite()

func _update_sprite() -> void:
	var norm_coord = _local_position / _LOCAL_SIZE
	var real_x_bound = _GLOBAL_SIZE.x - norm_coord.y * _TO_LOCAL_X_DIF
	var sprite_offset = norm_coord * Vector2(real_x_bound, -_GLOBAL_SIZE.y)
	sprite_offset.x += (_GLOBAL_SIZE.x - real_x_bound) / 2.
	
	
	
	scale = _SPRITE_RESCALE / ((norm_coord.y + 1.5))
	global_position = _ANCHOR_POINT_GLOBAL + sprite_offset
	global_position.y -= _BASE_SPRITE_HEIGHT * scale.y

func _enter_idle() -> void:
	_idle_is_moving = true
	_idle_target_position = _get_random_point()
	
	animation_player.play("walk")
	_flip_sprite_to_point(_idle_target_position)

func _enter_running() -> void:
	_current_task = _TASKS.keys().pick_random()
	
	animation_player.play("run")
	_flip_sprite_to_point(_TASKS[_current_task])

func _enter_blocking() -> void:
	blocking.emit(_current_task)
	
	animation_player.play("needs_attention")

func _process_idle(delta: float) -> void:
	if _idle_is_moving:
		_local_position = _local_position.move_toward(_idle_target_position, _IDLE_SPEED * delta)
		if _local_position.distance_to(_idle_target_position) < 1:
			_idle_is_moving = false
			_idle_timer = randf_range(_IDLE_TIME_RANGE.x, _IDLE_TIME_RANGE.y)
			
			animation_player.play("idle")
	
	else:
		_idle_timer -= delta
		if _idle_timer <= 0:
			if _sleep_cooldown_timer <= 0:
				_state = SLEEPING
				return
			
			_idle_is_moving = true
			_idle_target_position = _get_random_point()
			
			animation_player.play("walk")
			_flip_sprite_to_point(_idle_target_position)
	
	_new_task_timer -= delta
	if _new_task_timer <= 0:
		_state = RUNNING
		_enter_running()
	
	_sleep_cooldown_timer -= delta

func _process_running(delta: float) -> void:
	var task_position = _TASKS[_current_task]
	_local_position = _local_position.move_toward(task_position, _RUNNING_SPEED * delta)
	if _local_position.distance_to(task_position) < 1:
		_state = BLOCKING
		_enter_blocking()

func _process_blocking(delta: float) -> void:
	pass

func _process_sleeping(delta: float) -> void:
	if _local_position.distance_to(_SLEEP_POSITION) > 1:
		if animation_player.current_animation != "walk":
			animation_player.play("walk")
			_flip_sprite_to_point(_SLEEP_POSITION)
		
		_local_position = _local_position.move_toward(_SLEEP_POSITION, _IDLE_SPEED * delta)
		return
	
	if animation_player.current_animation != "sleep":
		animation_player.play("sleep")
		_sleep_timer = randf_range(_SLEEP_TIME_RANGE.x,_SLEEP_TIME_RANGE.y)
	
	_sleep_timer -= delta
	if _sleep_timer <= 0:
		_state = IDLE
		_enter_idle()
		_sleep_cooldown_timer = randf_range(_SLEEP_COOLDOWN_RANGE.x,_SLEEP_COOLDOWN_RANGE.y)

func _get_random_point() -> Vector2:
	var it = 0
	var new_point
	while it < 10:
		new_point = Vector2(randf_range(0,100),randf_range(0,100))
		if new_point.distance_to(_local_position) > 30:
			break
	
	return new_point

func _flip_sprite_to_point(point: Vector2) -> void:
	var flip = -sign(_local_position.direction_to(point).x)
	if flip:
		sprite_2d.scale.x = flip
