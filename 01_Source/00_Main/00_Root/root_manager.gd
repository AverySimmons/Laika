extends Node

@onready var main_menu_scene = preload("res://01_Source/01_Menus/00_MainMenu/main_menu.tscn")
@onready var game_manager_scene = preload("res://01_Source/00_Main/01_Game/game_manager.tscn")

@onready var mouse: Node = $Mouse

var current_scene : Node

func _ready() -> void:
	_create_title_screen()
	Data.custom_mouse = mouse

func _create_title_screen() -> void:
	current_scene = main_menu_scene.instantiate()
	current_scene.start_button_pressed.connect(_start_game)
	add_child(current_scene)

func _start_game() -> void:
	current_scene.queue_free()
	current_scene = game_manager_scene.instantiate()
	add_child(current_scene)
