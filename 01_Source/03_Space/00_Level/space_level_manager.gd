extends Node2D

var big_meteor_count = 0

@onready var score_pop_scene = preload("res://01_Source/03_Space/03_Score/score_popup.tscn")
@onready var health_up_scene = preload("res://01_Source/03_Space/03_Score/life_powerup.tscn")

@onready var starlayer_1: CPUParticles2D = $bg/starlayer1
@onready var starlayer_2: CPUParticles2D = $bg/starlayer2
@onready var starlayer_3: CPUParticles2D = $bg/starlayer3
@onready var starlayer_4: CPUParticles2D = $bg/starlayer4

@onready var life1: Sprite2D = $UI/Life1/Sprite2D
@onready var life2: Sprite2D = $UI/Life2/Sprite2D
@onready var life3: Sprite2D = $UI/Life3/Sprite2D


@export var space_scale = 1280:
	set(val):
		space_scale = val
		$bg.adjust_size(val)
		
		#var s = space_scale / 585.
		#
		#starlayer_1.amount = 50 * s
		#starlayer_2.amount = 32 * s
		#starlayer_3.amount = 22 * s
		#starlayer_4.amount = 15 * s
		#
		#starlayer_1.emission_rect_extents.x = 292.5 * s
		#starlayer_2.emission_rect_extents.x = 292.5 * s
		#starlayer_3.emission_rect_extents.x = 292.5 * s
		#starlayer_4.emission_rect_extents.x = 292.5 * s

var paused = true

# Spawn Scaling ====================================================================================

@onready var meteor_spawner: Node2D = $MeteorSpawner
@onready var enemy_spawner: Node2D = $EnemySpawner
@onready var enemies: Node = $Enemies
@onready var meteors: Node = $Meteors
@onready var projectiles: Node = $Projectiles
@onready var particles: Node = $Particles
@onready var player_scene = preload("res://01_Source/03_Space/01_Player/player_space.tscn")

var player: SpacePlayer

func _ready() -> void:
	SignalBus.score_death.connect(_create_score_popup)
	
	space_scale = 1280
	
	var s = space_scale / 585.
	
	starlayer_1.amount = 50 * s
	starlayer_2.amount = 32 * s
	starlayer_3.amount = 22 * s
	starlayer_4.amount = 15 * s
	
	starlayer_1.emission_rect_extents.x = 292.5 * s
	starlayer_2.emission_rect_extents.x = 292.5 * s
	starlayer_3.emission_rect_extents.x = 292.5 * s
	starlayer_4.emission_rect_extents.x = 292.5 * s
	
	
	meteor_spawner.meteors = meteors
	meteor_spawner.particles = particles
	enemy_spawner.enemies = enemies
	enemy_spawner.projectiles = projectiles
	enemy_spawner.particles = particles

func spawn_player() -> void:
	player = player_scene.instantiate()
	
	player.global_position = Vector2(640, 590)
	player.projectiles = projectiles
	player.particles = particles
	
	add_child(player)

func big_meteor_destroyed(pos: Vector2) -> void:
	big_meteor_count += 1
	if big_meteor_count >= 3 and player.cur_lives < player.max_lives:
		big_meteor_count = 0
		var new_power_up = health_up_scene.instantiate()
		new_power_up.global_position = pos
		$LifeUps.call_deferred("add_child", new_power_up)

func start_level() -> void:
	$UIAP.play("fade_in")
	await $UIAP.animation_finished
	
	
	paused = false
	player.unpause()
	
	SignalBus.change_player_lives.connect(adjust_player_lives)

func handle_mouse(local_mouse_pos: Vector2, is_click: bool, is_held: bool) -> void:
	if paused: return
	
	if is_held:
		Data.custom_mouse.cursor_type = Mouse.AIM
	else:
		Data.custom_mouse.cursor_type = Mouse.AIM2
	
	player.handle_mouse(local_mouse_pos, is_click, is_held)

func adjust_player_lives(lives: float) -> void:
	life1.visible = lives > 2
	life2.visible = lives > 1
	life3.visible = lives > 0

func _create_score_popup(pos: Vector2, score: float, size: float) -> void:
	var new_pop = score_pop_scene.instantiate()
	new_pop.global_position = pos
	new_pop.score = score
	new_pop.size = size
	$ScorePopups.add_child(new_pop)
	
	Data.score = clamp(Data.score + score, 0, 10000)
	
	var new_text = "Score: " + format_with_commas(int(Data.score))
	
	$UI/ScoreLabel.text = new_text

func format_with_commas(value: int) -> String:
	var str_value = str(value)
	var result = ""
	var count = 0
	
	for i in range(str_value.length() - 1, -1, -1):
		result = str_value[i] + result
		count += 1
		if count % 3 == 0 and i != 0:
			result = "," + result
	
	return result
