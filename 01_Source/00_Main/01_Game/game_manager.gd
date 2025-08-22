extends Node2D

@onready var cockpit_container: VBoxContainer = $Control/ScreenContainer/CockpitContainer
@onready var living_space_container: SubViewportContainer = $Control/ScreenContainer/CockpitContainer/LivingSpaceContainer
@onready var control_panel: TextureRect = $Control/ScreenContainer/CockpitContainer/ControlPanel
@onready var space_container: SubViewportContainer = $Control/ScreenContainer/SpaceContainer
@onready var living_space: Node2D = $Control/ScreenContainer/CockpitContainer/LivingSpaceContainer/SubViewport/CockpitLevel
@onready var space

@onready var control_panel_ap: AnimationPlayer = $Control/ScreenContainer/CockpitContainer/ControlPanel/ControlPanelAP


enum {COCKPIT, SPACE}

var current_focus = COCKPIT

func _ready() -> void:
	_connect_signals()

func _physics_process(_delta: float) -> void:
	_handle_click()

func _connect_signals() -> void:
	living_space.laika_started_blocking.connect(_laika_start_blocking)
	living_space.minigame_complete.connect(_minigame_won)
	cockpit_container.mouse_entered.connect(_cockpit_mouse_entered)
	space_container.mouse_entered.connect(_space_mouse_entered)

func _laika_start_blocking() -> void:
	control_panel_ap.play("error")

func _minigame_won() -> void:
	control_panel_ap.play("normal")

func _cockpit_mouse_entered() -> void:
	current_focus = COCKPIT

func _space_mouse_entered() -> void:
	Data.custom_mouse.cursor_type = Mouse.AIM
	current_focus = SPACE

func _handle_click() -> void:
	if current_focus == SPACE:
		var is_click = Input.is_action_just_pressed("click")
		var is_held = Input.is_action_pressed("click")
		is_click = is_click and not living_space.laika_blocking
		is_held = is_held and not living_space.laika_blocking
		
		var mouse_pos = get_global_mouse_position()
		var local_mouse_pos = mouse_pos - space_container.global_position
		#space.handle_mouse(local_mouse_pos, is_click, is_held)
	
	else:
		var is_click = Input.is_action_just_pressed("click")
		var is_held = Input.is_action_pressed("click")
		
		var mouse_pos = get_global_mouse_position()
		var local_mouse_pos = mouse_pos - living_space_container.global_position
		living_space.handle_mouse(local_mouse_pos, is_click, is_held)
