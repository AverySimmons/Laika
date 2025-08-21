extends Minigame

const _NEEDED_MOUSE_DIST = 1000

var _mouse_dist = 0
var _last_mouse_position = Vector2.ZERO

func _init() -> void:
	_locks = 2

func _process(delta: float) -> void:
	super._process(delta)
	
	handle_mouse(get_global_mouse_position(), Input.is_action_just_pressed("click"), Input.is_action_pressed("click"))
	#print(_mouse_dist)
	#print(_letter_queue)
	#print(_locks)

func handle_mouse(local_mouse_pos, is_click, is_held) -> void:
	super.handle_mouse(local_mouse_pos, is_click, is_held)
	
	if _locks != 2:
		return
	
	if _last_mouse_position == Vector2.ZERO:
		_last_mouse_position = local_mouse_pos
		return
	
	if is_held:
		_mouse_dist += _last_mouse_position.distance_to(local_mouse_pos)
		if _mouse_dist > _NEEDED_MOUSE_DIST:
			_open_lock()
			_extend_letter_queue("GOOD_GIRL")
			_spawn_letter()
	
	_last_mouse_position = local_mouse_pos
