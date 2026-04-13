extends Control

@onready var health_bar = $HealthBar
@onready var wealth_label = $WealthLabel

func update_wealth_display(amount: int):
	wealth_label.text = "Coins: " + str(amount)
	
func setup_ui_components(max_health: float):
	var margin = 20
	health_bar.position = Vector2(margin, margin)
	wealth_label.position = Vector2(get_viewport_rect().size.x - wealth_label.size.x - margin, margin)
	
	var bar_width = max_health * 2.0
	var bar_height = 24.0
	
	health_bar.custom_minimum_size = Vector2(bar_width, bar_height)
	health_bar.size = health_bar.custom_minimum_size
	
func update_from_turret(turret_max_health: float):
	setup_ui_components(turret_max_health)

	
