extends Area2D
class_name Enemy

@export var speed: float = 100.0
@export var health: float = 100.0
@export var damage_per_hit: float = 1.0
@export var hit_rate: float = 1.0

var target = null

func _ready():
	target = get_tree().current_scene.find_child("TurretPlatform", true, false)
	
func _process(delta):
	if target:
		var direction = (target.global_position - global_position).normalized()
		
		global_position += direction * speed * delta
		
		look_at(target.global_position)
		
func take_damage(amount: float):
	health -= amount
	if health <= 0:
		die()
		
func die():
	queue_free()
