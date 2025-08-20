extends Node2D

@onready var cockpit_container: VBoxContainer = $HBoxContainer/CockpitContainer
@onready var living_space_container: SubViewportContainer = $HBoxContainer/CockpitContainer/LivingSpaceContainer
@onready var control_panel_container: SubViewportContainer = $HBoxContainer/CockpitContainer/ControlPanelContainer
@onready var space_container: SubViewportContainer = $HBoxContainer/SpaceContainer
@onready var living_space
@onready var control_panel
@onready var space

enum {COCKPIT, SPACE}

var current_focus = COCKPIT

func _ready() -> void:
	_connect_signals()

func _physics_process(delta: float) -> void:
	_handle_click()

func _connect_signals() -> void:
	cockpit_container.mouse_entered.connect(_cockpit_mouse_entered)
	space_container.mouse_entered.connect(_space_mouse_entered)

func _cockpit_mouse_entered() -> void:
	Data.custom_mouse.set_type(Mouse.COCKPIT)
	current_focus = COCKPIT

func _space_mouse_entered() -> void:
	Data.custom_mouse.set_type(Mouse.SPACE)
	current_focus = SPACE

func _handle_click() -> void:
	if current_focus == SPACE:
		if Input.is_action_pressed("click"):
			if living_space.laika_blocking:
				pass
			else:
				var mouse_pos = get_global_mouse_position()
				var local_mouse_pos = mouse_pos - space_container.global_position
				space.handle_click(local_mouse_pos)
	
	else:
		if Input.is_action_just_pressed("click"):
			var mouse_pos = get_global_mouse_position()
			var local_mouse_pos = mouse_pos - living_space_container.global_position
			living_space.handle_click(local_mouse_pos)
