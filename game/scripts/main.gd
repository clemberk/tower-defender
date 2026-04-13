extends Node2D

@onready var turret = $Turret
@onready var ui_container = $UI/UIContainer
@onready var ui_health_bar = $UI/UIContainer/HealthBar
@onready var shop_menu = $UI/ShopMenu
@onready var stats_label = $UI/UIContainer/StatsLabel

var time_elapsed: float = 0.0
var kill_count: int = 0
var current_level: int = 1

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
	
func _process(delta: float):
	time_elapsed += delta
	update_stats_label()

func format_time(time_in_seconds: float) -> String:
	var minutes: int = int(time_in_seconds / 60)
	var seconds: int = int(time_in_seconds) % 60
	return "%d:%02d" % [minutes, seconds]
	
	
func _on_enemy_killed():
	kill_count += 1
	
func _on_level_up():
	current_level += 1

func _on_turret_health_depleted():
	game_over()

func center_turret():
	var viewport_size = get_viewport_rect().size
	turret.position = viewport_size / 2

func update_stats_label():
	var weapon = turret.current_weapon
	if not weapon: return

	var avg_dmg = (weapon.damage_range.x + weapon.damage_range.y) / 2.0
	var dps = avg_dmg * weapon.fire_rate

	var text = "Time: " + format_time(time_elapsed) + "\n"
	text += "Level: " + str(current_level) + "\n"
	text += "Kills: " + str(kill_count) + "\n"
	text += "Damage Range: " + str(weapon.damage_range.x) + " - " + str(weapon.damage_range.y) + "\n"
	text += "DPS: " + str(snapped(dps, 0.1)) + "\n" # Auf 1 Nachkommastelle runden
	text += "Fire Rate: " + str(weapon.fire_rate) + "/s\n"
	text += "Crit Chance: " + str(weapon.crit_chance) + "%\n"
	text += "Crit Multiplier: " + str(weapon.crit_multiplier) + "%"

	stats_label.text = text
	
func game_over():
	turret.die()
	print("Game Over")
	get_tree().reload_current_scene()
