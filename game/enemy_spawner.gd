extends Node2D

@export var goblin_enemy_scene = preload("res://goblin_enemy.tscn")
@export var spawn_rate: float = 2.0

@onready var spawn_timer = $SpawnTimer

func _ready() -> void:
	spawn_timer.wait_time = 1 / spawn_rate
	
func _on_spawn_timer_timeout():
	spawn_enemy()
	
func spawn_enemy():
	if !goblin_enemy_scene: return
	
	var goblin = goblin_enemy_scene.instantiate()
	add_child(goblin)
	
	goblin.global_position = get_random_border_position()
	

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
	
