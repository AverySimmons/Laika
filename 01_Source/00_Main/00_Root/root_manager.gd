extends Node

@onready var _main_menu_scene = preload("res://01_Source/01_Menus/00_MainMenu/main_menu.tscn")
@onready var _game_manager_scene = preload("res://01_Source/00_Main/01_Game/game_manager.tscn")
@onready var _settings_scene = preload("res://01_Source/01_Menus/01_Settings/settings_menu.tscn")
@onready var _space_scene = preload("res://01_Source/03_Space/00_Level/space_level.tscn")

@onready var mouse: Node = $Mouse
@onready var menu_music: AudioStreamPlayer = $MenuMusic
@onready var game_music: AudioStreamPlayer = $GameMusic
@onready var animation_player: AnimationPlayer = $ColorRect/AnimationPlayer
@onready var game_over_ap: AnimationPlayer = $GameOverScreen/GameOverAP
@onready var score_label: RichTextLabel = $GameOverScreen/ScoreLabel
@onready var ship_ambience: AudioStreamPlayer = $ShipAmbience


@onready var space: Node2D

var _current_node : Node
var _settings_node : Node

var _current_music : AudioStreamPlayer

func _ready() -> void:
	SignalBus.lose.connect(_player_death)
	Data.custom_mouse = mouse
	Data.custom_mouse.cursor_type = Mouse.INTERACT
	
	_spawn_game()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("settings"):
		_enter_settings()

func _spawn_game() -> void:
	_current_music = menu_music
	_current_music.volume_linear = 0
	_current_music.play()
	
	var t = create_tween()
	t.tween_property(_current_music, "volume_linear", 1, 0.5)
	
	space = _space_scene.instantiate()
	add_child(space)
	
	_create_title_screen()

func _enter_settings() -> void:
	if _settings_node or get_tree().paused: return
	
	_settings_node = _settings_scene.instantiate()
	_settings_node.settings_closed.connect(_exit_settings)
	add_child(_settings_node)
	get_tree().paused = true
	
	var t = create_tween()
	t.tween_property(_current_music, "volume_linear", 0.5, 0.2)

func _exit_settings() -> void:
	get_tree().paused = false
	
	var t = create_tween()
	t.tween_property(_current_music, "volume_linear", 1, 0.2)

func _create_title_screen() -> void:
	_current_node = _main_menu_scene.instantiate()
	_current_node.start_button_pressed.connect(_start_game)
	add_child(_current_node)

func _start_game() -> void:
	remove_child(space)
	
	_current_node.queue_free()
	_current_node = _game_manager_scene.instantiate()
	_current_node.space = space
	add_child(_current_node)
	
	ship_ambience.volume_linear = 0
	ship_ambience.play()
	var t = create_tween()
	t.tween_property(ship_ambience, "volume_linear", 1, 1)
	
	_start_playable()

func _start_playable() -> void:
	var t = create_tween()
	t.tween_property(_current_music, "volume_linear", 0, 0.2)
	
	_current_music = game_music
	_current_music.volume_linear = 0
	_current_music.play()
	
	var t2 = create_tween()
	t2.tween_property(_current_music, "volume_linear", 1, 0.2)

func _player_death() -> void:
	await get_tree().create_timer(0.2).timeout
	
	get_tree().paused = true
	
	Data.custom_mouse.cursor_type = Mouse.INTERACT
	Data.custom_mouse.emit_hearts = false
	
	score_label.text = "[shake rate=20.0 level=20 connected=1]Score: " + str(Data.score)
	
	await get_tree().create_timer(0.2).timeout
	
	var t = create_tween()
	t.tween_property(_current_music, "volume_linear", 0, 2)
	
	game_over_ap.play("enter")
	await game_over_ap.animation_finished
	
	await get_tree().create_timer(2).timeout
	
	var t2 = create_tween()
	t2.tween_property(ship_ambience, "volume_linear", 0, 1)
	
	animation_player.play("darken")
	await animation_player.animation_finished
	
	_current_node.queue_free()
	menu_music.stop()
	game_music.stop()
	ship_ambience.stop()
	
	_spawn_game()
	get_tree().paused = false
	
	await get_tree().physics_frame
	$ColorRect.modulate.a = 0
