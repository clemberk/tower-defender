extends ProgressBar

func setup(max_hp: float):
	max_value = max_hp
	value = max_hp
	
func update_health(current_hp: float):
	value = current_hp
