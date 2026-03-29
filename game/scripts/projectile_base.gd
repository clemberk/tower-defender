extends Area2D
class_name Projectile


@export var speed: float = 500.0
@export var damage: float = 1.0
@export var fire_rate: float = 1.0

func _process(delta: float):
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * speed * delta
	
func _on_body_entered(_body):
	execute_hit()
	
func execute_hit():
	queue_free()
	print("Projectile removed (Hit)")


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
	print("Projectile removed (Outside Viewport)")


func _on_area_entered(area: Area2D) -> void:
	if area is Enemy:
		area.take_damage(damage)
		queue_free()
