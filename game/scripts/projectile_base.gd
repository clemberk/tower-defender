extends Area2D
class_name Projectile

@export var speed: float = 500.0
@export var damage: float = 1.0

func _process(delta: float):
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * speed * delta
	
func _on_body_entered(_body):
	execute_hit()
	
func execute_hit():
	queue_free()
