extends Sprite2D

signal blocking()

## IDLE: pick a location, walk there, sit for a little, repeat
## RUNNING: run to chosen task
## BLOCKING: block at chosen task until clicked

enum {IDLE, RUNNING, BLOCKING}
enum {PET, FEED, CLEAN}

const TASKS: Dictionary[int, Vector2] = {
	PET : Vector2(),
	FEED : Vector2(),
	CLEAN : Vector2(),
}

const _IDLE_SPEED = 200
const _RUNNING_SPEED = 400
const _NEW_TASK_TIME_RANGE = Vector2(5, 10)
const _IDLE_TIME_RANGE = Vector2(1, 2)
const _GLOBAL_SIZE = Vector2(100, 20)
const _LOCAL_SIZE = Vector2(100, 100)

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var _local_position = Vector2.ZERO
var _state = IDLE
var _current_task = PET
var _new_task_timer = 0

var _idle_timer = 0
var _idle_is_moving = false
var _idle_target_position = Vector2.ZERO

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
	
	_update_sprite()

func _update_sprite() -> void:
	pass

func _enter_idle() -> void:
	_idle_is_moving = true
	_idle_target_position = _get_random_point()

func _enter_running() -> void:
	_current_task = randi_range(IDLE, BLOCKING)

func _enter_blocking() -> void:
	blocking.emit()

func _process_idle(delta: float) -> void:
	
	
	if _idle_is_moving:
		_local_position = _local_position.move_toward(_idle_target_position, _IDLE_SPEED * delta)
		if _local_position.distance_to(_idle_target_position) < 1:
			_idle_is_moving = false
			_idle_timer = randf_range(_IDLE_TIME_RANGE.x, _IDLE_TIME_RANGE.y)
	
	else:
		_idle_timer -= delta
		if _idle_timer <= 0:
			_idle_is_moving = true
			_idle_target_position = _get_random_point()
	
	_new_task_timer -= delta
	if _new_task_timer <= 0:
		_state = RUNNING
		_enter_running()

func _process_running(delta: float) -> void:
	var task_position = TASKS[_current_task]
	_local_position = _local_position.move_toward(task_position, _RUNNING_SPEED * delta)
	if _local_position.distance_to(task_position) < 1:
		_state = BLOCKING
		_enter_blocking()

func _process_blocking(delta: float) -> void:
	pass

func _get_random_point() -> Vector2:
	return Vector2.ZERO
