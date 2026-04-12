extends Node2D

@export var goblin_enemy_scene = preload("res://goblin_enemy.tscn")
@export var ogre_enemy_scene = preload("res://ogre_enemy.tscn")

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

func _ready() -> void:
	spawn_timer.wait_time = 1 / spawn_rate
	
func _on_spawn_timer_timeout():
	spawn_enemy()
	
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
	
