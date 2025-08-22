extends Node

@onready var _main_menu_scene = preload("res://01_Source/01_Menus/00_MainMenu/main_menu.tscn")
@onready var _game_manager_scene = preload("res://01_Source/00_Main/01_Game/game_manager.tscn")
@onready var _settings_scene = preload("res://01_Source/01_Menus/01_Settings/settings_menu.tscn")

@onready var mouse: Node = $Mouse
@onready var menu_music: AudioStreamPlayer = $MenuMusic
@onready var game_music: AudioStreamPlayer = $GameMusic
@onready var space: Node2D = $SpaceLevel

var _current_node : Node
var _settings_node : Node

var _current_music : AudioStreamPlayer

func _ready() -> void:
	_create_title_screen()
	Data.custom_mouse = mouse
	Data.custom_mouse.cursor_type = Mouse.INTERACT
	
	_current_music = menu_music
	_current_music.volume_linear = 0
	_current_music.play()
	
	var t = create_tween()
	t.tween_property(_current_music, "volume_linear", 1, 0.5)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("settings"):
		_enter_settings()

func _enter_settings() -> void:
	if _settings_node: return
	
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
	_start_playable()

func _start_playable() -> void:
	var t = create_tween()
	t.tween_property(_current_music, "volume_linear", 0, 0.2)
	
	_current_music = game_music
	_current_music.volume_linear = 0
	_current_music.play()
	
	var t2 = create_tween()
	t2.tween_property(_current_music, "volume_linear", 1, 0.2)
