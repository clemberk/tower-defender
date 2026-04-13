extends Node2D

@export var goblin_enemy_scene = preload("res://goblin_enemy.tscn")
@export var ogre_enemy_scene = preload("res://ogre_enemy.tscn")

@export var level_duration: float = 20.0
var current_level: int = 1

@onready var enemy_scenes: Dictionary = {
	"goblin": goblin_enemy_scene,
	"ogre": ogre_enemy_scene
}

var spawn_rates: Dictionary = {
	"goblin": 70,
	"ogre": 30
}

@export var spawn_rate: float = 1.0
@onready var spawn_timer = $SpawnTimer
@onready var level_timer = Timer.new()

func _ready() -> void:
	spawn_timer.wait_time = 1 / spawn_rate
	
	add_child(level_timer)
	level_timer.wait_time = level_duration
	level_timer.autostart = true
	level_timer.timeout.connect(_on_level_timer_timeout)
	level_timer.start()
	
func _on_spawn_timer_timeout():
	spawn_enemy()

func _on_level_timer_timeout():
	current_level += 1
	spawn_rate *= 1.5
	
	spawn_timer.wait_time = 1.0 / spawn_rate 
	
	if get_tree().current_scene.has_method("_on_level_up"):
		get_tree().current_scene._on_level_up()
	
func spawn_enemy():
	if !enemy_scenes: return
	
	var roll_100 = randi_range(0, 100)
	var current_weigth = 0
	
	for enemy_name in spawn_rates:
		current_weigth += spawn_rates[enemy_name]
		if roll_100 <= current_weigth:
			spawn_instantiate(enemy_name)
			return
			
func spawn_instantiate(enemy_type: String):
	var scene_to_spawn = enemy_scenes[enemy_type]
	
	if scene_to_spawn:
		var enemy = scene_to_spawn.instantiate()
		get_tree().current_scene.add_child(enemy)
		
		enemy.enemy_killed.connect(func(): 
			if get_tree().current_scene.has_method("_on_enemy_killed"):
				get_tree().current_scene._on_enemy_killed()
		)
		
		enemy.global_position = get_random_border_position()
		
		
func get_random_border_position() -> Vector2:
	var viewport_size = get_viewport_rect().size
	
	# 0: Top; 1: Right; 2: Bottom; 3: Left
	var side = randi() % 4 
	var pos = Vector2.ZERO
	
	match side:
		0: pos = Vector2(randf_range(0, viewport_size.x), -50)
		1: pos = Vector2(viewport_size.x + 50, randf_range(0, viewport_size.y))
		2: pos = Vector2(randf_range(0, viewport_size.x), viewport_size.y + 50)
		3: pos = Vector2(-50, randf_range(0, viewport_size.y))
		
	return pos
	
