extends Area2D

signal health_changed(new_value)
signal health_depleted

var max_health: int = 100
var current_health: int = 100
var coins: int = 0

func add_coin(amount: int):
	coins+= amount

	
func take_damage(amount: int):
	current_health -= amount
	health_changed.emit(current_health)
	
	print(current_health)
		
	if current_health <= 0:
		health_depleted.emit()
		
		
func die():
	queue_free()
