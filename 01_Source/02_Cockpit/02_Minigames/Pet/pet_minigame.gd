extends Minigame

## intro cutscene
## sound effects
## music

const _NEEDED_MOUSE_DIST = 1500

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var fade_player: AnimationPlayer = $FadePlayer


var _mouse_dist = 0
var _last_mouse_position = Vector2.ZERO
var _petting_started = false

func _init() -> void:
	_locks = 2

func handle_mouse(local_mouse_pos, is_click, is_held) -> void:
	super.handle_mouse(local_mouse_pos, is_click, is_held)
	
	if _locks != 2:
		return
	
	if _last_mouse_position == Vector2.ZERO:
		_last_mouse_position = local_mouse_pos
		return
	
	if is_held and not fade_player.is_playing():
		if not animation_player.is_playing():
			if _petting_started:
				animation_player.play("petting")
			else:
				animation_player.play("start_petting")
				_petting_started = true
				Data.custom_mouse.emit_hearts = true
				$Pant.play()
				$Pet.play()
		
		_mouse_dist += _last_mouse_position.distance_to(local_mouse_pos)
		if _mouse_dist > _NEEDED_MOUSE_DIST:
			_open_lock()
			_spawn_letter_lock("GOOD GIRL!")
			Data.custom_mouse.emit_hearts = false
			
			var t = create_tween()
			t.tween_property($PetLabel, "modulate:a", 0., 0.2)
	
	else:
		_petting_started = false
		animation_player.play("not_petting")
		Data.custom_mouse.emit_hearts = false
		_mouse_dist = 0
		
		$Pant.stop()
		$Pet.stop()
	
	_last_mouse_position = local_mouse_pos

func _win() -> void:
	fade_player.play("exit")
	await fade_player.animation_finished
	Data.custom_mouse.emit_hearts = false
	success.emit()
	queue_free()
