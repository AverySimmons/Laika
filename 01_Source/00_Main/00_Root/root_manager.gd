extends Node

@onready var _main_menu_scene = preload("res://01_Source/01_Menus/00_MainMenu/main_menu.tscn")
@onready var _game_manager_scene = preload("res://01_Source/00_Main/01_Game/game_manager.tscn")
@onready var _settings_scene = preload("res://01_Source/01_Menus/01_Settings/settings_menu.tscn")

@onready var mouse: Node = $Mouse

var _current_node : Node
var _settings_node : Node

func _ready() -> void:
	_create_title_screen()
	Data.custom_mouse = mouse
	Data.custom_mouse.cursor_type = Mouse.INTERACT

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("settings"):
		_enter_settings()

func _enter_settings() -> void:
	if _settings_node: return
	
	_settings_node = _settings_scene.instantiate()
	_settings_node.settings_closed.connect(_exit_settings)
	add_child(_settings_node)
	get_tree().paused = true

func _exit_settings() -> void:
	get_tree().paused = false

func _create_title_screen() -> void:
	_current_node = _main_menu_scene.instantiate()
	_current_node.start_button_pressed.connect(_start_game)
	add_child(_current_node)

func _start_game() -> void:
	_current_node.queue_free()
	_current_node = _game_manager_scene.instantiate()
	add_child(_current_node)
