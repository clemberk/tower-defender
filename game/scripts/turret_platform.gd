extends Sprite2D

@export var health: float = 100.0

func take_damage(amount: float):
	health -= amount
	print("Health left:", health)
	if health <= 0:
		die()
		print("Game Over")
		get_tree().reload_current_scene()
		
func die():
	queue_free()
