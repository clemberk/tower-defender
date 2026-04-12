extends Node2D

@onready var turret = $Turret
@onready var ui_container = $UI/UIContainer
@onready var ui_health_bar = $UI/UIContainer/HealthBar


func _ready():
	ui_container.setup_ui_components(turret.max_health)
	
	center_turret()
	get_viewport().size_changed.connect(center_turret)
	
	turret.health_changed.connect(ui_health_bar.update_health)
	turret.health_depleted.connect(_on_turret_health_depleted)
	turret.wealth_changed.connect(ui_container.update_wealth_display)
	
	ui_health_bar.setup(turret.max_health)
	ui_container.update_wealth_display(turret.coins)
	
	randomize() # every new game should start with different rolls
	
func _on_turret_health_depleted():
	game_over()

func center_turret():
	var viewport_size = get_viewport_rect().size
	turret.position = viewport_size / 2

func game_over():
	turret.die()
	print("Game Over")
	get_tree().reload_current_scene()
