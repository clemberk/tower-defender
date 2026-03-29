extends Area2D
class_name Enemy

@export var speed: float = 100.0
@export var health: float = 100.0
@export var damage_per_hit: float = 2.0
@export var hit_rate: float = 1.0
@export var attack_dash_distancee: float = 15.0

var target = null
var can_attack_atm: bool = true
var stop_distance: float = 50.0

func _ready():
	target = get_tree().current_scene.find_child("TurretPlatform", true, false)
	if target == null:
		print("Turret not found")
	
func _process(delta):
	if not target:
		return
		
	var distance_to_target = global_position.distance_to(target.global_position)
	
	if distance_to_target > stop_distance:
		var direction = (target.global_position - global_position).normalized()
		global_position += direction * speed * delta
		look_at(target.global_position)
	else:
		if can_attack_atm:
			attack_target()
			
func attack_target():
	# Check if Scene is currently there
	if not is_inside_tree():
		return
		
	can_attack_atm = false
	
	var attack_dash_direction = (target.global_position - global_position).normalized()
	var original_position = global_position
	var target_dash_position = original_position + (attack_dash_direction * attack_dash_distancee)
	
	var tween = create_tween()
	
	tween.tween_property(self, "global_position", target_dash_position, 0.1).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	
	if target.has_method("take_damage"):
		target.take_damage(damage_per_hit)
		
	print("Enemy hits turret! Damage: ", damage_per_hit)
		
	tween.tween_property(self, "global_position", original_position, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	var tree = get_tree()
	if tree:
		await tree.create_timer(hit_rate).timeout
		
	can_attack_atm = true
	
func take_damage(amount: float):
	health -= amount
	if health <= 0:
		die()
		
func die():
	queue_free()
