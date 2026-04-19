extends Node2D

@onready var turret = $Turret
@onready var ui_container = $UI/UIContainer
@onready var ui_health_bar = $UI/UIContainer/HealthBar
@onready var shop_menu = $UI/ShopMenu
@onready var stats_label = $UI/UIContainer/StatsLabel

var time_elapsed: float = 0.0
var kill_count: int = 0
var current_level: int = 1
var final_score: int = 0

var dying_sounds = [
	preload("res://assets/audio/dying_1.mp3"),
	preload("res://assets/audio/dying_2.mp3"),
	preload("res://assets/audio/dying_3.mp3"),
	preload("res://assets/audio/dying_4.mp3")
]

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
	if not get_tree().paused and is_inside_tree():
		update_stats_label()

func format_time(time_in_seconds: float) -> String:
	var minutes: int = int(time_in_seconds / 60)
	var seconds: int = int(time_in_seconds) % 60
	return "%d:%02d" % [minutes, seconds]
	

	
func _on_enemy_killed(enemy_name):
	kill_count += 1
	
	var temp_audio = AudioStreamPlayer.new()
	add_child(temp_audio)
	
	if enemy_name == "Goblin" or enemy_name == "Ogre" or enemy_name == "Orc":
		temp_audio.stream = dying_sounds.pick_random()
		temp_audio.play()
	
	temp_audio.finished.connect(temp_audio.queue_free)

	
func _on_level_up():
	current_level += 1

func _on_turret_health_depleted():
	final_score = int(time_elapsed) * kill_count
	
	get_tree().paused = true
	
	var highscore_panel = $UI/UIContainer/HighscorePanel
	highscore_panel.show()
	
	if highscore_panel.has_node("HighscoreDisplayLabel"):
		highscore_panel.get_node("HighscoreDisplayLabel").text = "Score: " + str(final_score)
		
	$UI/UIContainer/HighscorePanel/VBoxContainer/HighscoreName.grab_focus()
	
	SaveSystem.is_new_highscore(final_score)
	
	game_over()

func center_turret():
	# var viewport_size = get_viewport_rect().size
	turret.position = Vector2.ZERO

func update_stats_label():
	var weapon = turret.current_weapon
	if not weapon: return

	var avg_dmg = (weapon.damage.x + weapon.damage.y) / 2.0
	var dps = avg_dmg * weapon.fire_rate
	final_score = int(time_elapsed) * kill_count
	
	var text: String = ""
	text += "Score: " + str(final_score) + "\n"
	text += "Time: " + format_time(time_elapsed) + "\n"
	text += "Level: " + str(current_level) + "\n"
	text += "Kills: " + str(kill_count) + "\n"
	text += "Damage Range: " + str(int(weapon.damage.x)) + " - " + str(int(weapon.damage.y)) + "\n"
	text += "DPS: " + str(snapped(dps, 0.1)) + "\n" 
	text += "Fire Rate: " + str(snapped(weapon.fire_rate, 0.1)) + "/s\n"
	text += "Crit Chance: " + str(snapped(weapon.crit_chance, 0.1)) + "%\n"
	text += "Crit Multiplier: " + str(snapped(weapon.crit_multiplier, 0.1)) + "%"

	stats_label.text = text
	
func game_over():
	turret.die()
	print("Game Over")


func _on_submit_highscore_pressed() -> void:
	var p_name = $UI/UIContainer/HighscorePanel/VBoxContainer/HighscoreName.text
	if p_name == "": p_name = "Anonymous"
	
	print("Highscore saved")
	
	SaveSystem.add_highscore(p_name, final_score)
	
	get_tree().paused = false
	get_tree().change_scene_to_file("res://main_menu.tscn")
