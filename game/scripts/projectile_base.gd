extends Area2D
class_name Projectile


@export var speed: float = 0.0
@export var fire_rate: float = 0.0
@export var damage_range: Vector2 = Vector2(0.0, 0.0)
@export var crit_chance: float = 0.0
@export var crit_multiplier: float = 0.0


func _process(delta: float):
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * speed * delta
	
	
func _on_body_entered(_body):
	execute_hit()
	
	
func calculate_hit_damage():
	var hit_damage: float = 0.0
	var hit_is_crit: bool = false
	
	hit_damage = randf_range(damage_range.x, damage_range.y)
	
	if randf()*100 < crit_chance:
		hit_is_crit = true
		
	if hit_is_crit:
		hit_damage *= ((100.0 + crit_multiplier)/100.0)
		print("CRIT!")
		
	return {
		"damage": snapped(hit_damage, 0.1), # rounds hit_damage with one digit after comma
		"is_crit": hit_is_crit
	}
	
	
func execute_hit():
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area is Enemy:
		var enemy = area
		var hit = calculate_hit_damage()
		enemy.take_damage(hit.damage, hit.is_crit)
		queue_free()
