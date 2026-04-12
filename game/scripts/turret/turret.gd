extends Area2D

signal health_changed(new_value)
signal health_depleted
signal wealth_changed(new_amount)

var max_health: int = 100
var current_health: int = 100
var coins: int = 0

func add_coin(amount: int):
	coins+= amount
	wealth_changed.emit(coins)

	
func take_damage(amount: int):
	current_health -= amount
	health_changed.emit(current_health)
	
	print(current_health)
		
	if current_health <= 0:
		health_depleted.emit()
		
		
func die():
	queue_free()
