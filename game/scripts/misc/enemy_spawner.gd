extends Node2D

@export var orc_enemy_scene = preload("res://scenes/enemies/orc_enemy.tscn")
@export var orc_rider_enemy_scene = preload("res://scenes/enemies/orc_rider_enemy.tscn")
@export var armored_lumberjack_scene = preload("res://scenes/enemies/armored_lumberjack.tscn")
@export var armored_orc_scene = preload("res://scenes/enemies/armored_orc.tscn")
@export var skeleton_scene = preload("res://scenes/enemies/skeleton_enemy.tscn")
@export var slime_scene = preload("res://scenes/enemies/slime_enemy.tscn")
@export var nightborne_boss_scene = preload("res://scenes/enemies/nightborne_boss.tscn")

@export var level_duration: float = 20.0

var current_level: int = 1
var is_boss_stage: bool = false
var enemy_health_multiplier: float = 1.0
var coin_drop_multiplier: float = 1.0

@export var spawn_rate: float = 1.0
@onready var spawn_timer = $SpawnTimer
@onready var level_timer = Timer.new()

@onready var enemy_scenes: Dictionary = {
	"orc": orc_enemy_scene,
	"orc_rider": orc_rider_enemy_scene,
	"armored_lumberjack": armored_lumberjack_scene,
	"armored_orc": armored_orc_scene,
	"skeleton": skeleton_scene,
	"slime": slime_scene,
	"nightborne": nightborne_boss_scene
}

var spawn_rates: Dictionary = {
	"orc": 30,
	"skeleton": 20,
	"slime": 20,
	"armored_orc": 10,
	"armored_lumberjack": 10,
	"orc_rider": 10,
}

func _ready() -> void:
	spawn_timer.wait_time = 1 / spawn_rate
	
	add_child(level_timer)
	level_timer.wait_time = level_duration
	level_timer.autostart = true
	level_timer.timeout.connect(_on_level_timer_timeout)
	level_timer.start()
	
func _on_spawn_timer_timeout():
	if not is_boss_stage:
		spawn_common_enemy()

func _on_level_timer_timeout():
	current_level += 1
	
	if current_level % 5 == 0:
		start_boss_stage()
	else:
		spawn_rate *= 1.1
		spawn_timer.wait_time = 1.0 / spawn_rate 
	
	if get_tree().current_scene.has_method("_on_level_up"):
		get_tree().current_scene._on_level_up()
	
func spawn_common_enemy():
	if !enemy_scenes: return
	
	var roll_100 = randi_range(0, 100)
	var current_weigth = 0
	
	for enemy_name in spawn_rates:
		current_weigth += spawn_rates[enemy_name]
		if roll_100 <= current_weigth:
			spawn_instantiate(enemy_name)
			return
			
func start_boss_stage():
	is_boss_stage = true
	level_timer.paused = true
	
	var boss = nightborne_boss_scene.instantiate()
	get_tree().current_scene.add_child(boss)
	boss.global_position = get_random_border_position()
	
	boss.defeated.connect(_on_boss_defeated)
	
func _on_boss_defeated():
	is_boss_stage = false
	level_timer.paused = false
	
	enemy_health_multiplier *= 2.0
	coin_drop_multiplier *= 1.3
	
	spawn_rate *= 1.2
	spawn_timer.wait_time = 1.0 / spawn_rate
	
			
func spawn_instantiate(enemy_type: String):
	var scene_to_spawn = enemy_scenes[enemy_type]
	
	if scene_to_spawn:
		var enemy = scene_to_spawn.instantiate()
		get_tree().current_scene.add_child(enemy)
		
		if enemy.get("max_health"):
			enemy.max_health *= enemy_health_multiplier
			enemy.current_health *= enemy_health_multiplier 
		
		if enemy.get("base_coin_drop_amount"):
			enemy.base_coin_drop_amount *= coin_drop_multiplier
			
		enemy.global_position = get_random_border_position()
		
		
func get_random_border_position() -> Vector2:
	# 0: Top; 1: Right; 2: Bottom; 3: Left
	var side = randi() % 4 
	var radius = 1000
	
	match side:
		0: return Vector2(randf_range(-radius, radius), -radius) 
		1: return Vector2(radius, randf_range(-radius, radius))  
		2: return Vector2(randf_range(-radius, radius), radius)  
		3: return Vector2(-radius, randf_range(-radius, radius)) 
		
	return Vector2.ZERO
	
