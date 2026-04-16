extends Area2D

@onready var cannon = $TurretPlatform/Cannon
@onready var current_weapon: Weapon = cannon
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer

signal health_changed(new_value)
signal health_depleted
signal wealth_changed

var max_health: float = 100.0
var current_health: float = 100.0
var coins: int = 0

var upgrades = {
	"damage": {
		"level": 1,
		"current_cost": 40,
		"multiplier": 1.25
	},
	"fire_rate": {
		"level": 1,
		"current_cost": 80,
		"multiplier": 1.25
	},
	"crit_chance": {
		"level": 1,
		"current_cost": 70,
		"multiplier": 1.5
	},
	"crit_multiplier": {
		"level": 1,
		"current_cost": 70,
		"multiplier": 1.5
	}
}	

func _ready():
	update_shop_ui()
	audio_player.stream = load("res://assets/audio/cannon_shooting.mp3")
	
func _process(_delta):
	current_weapon.look_at(get_global_mouse_position())
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and current_weapon.can_shoot_atm:
		current_weapon.shoot_projectile()
		audio_player.play()
		
	
func buy_upgrade(upgrade_name: String):
	if not upgrades.has(upgrade_name):
		return
		
	var upgr = upgrades[upgrade_name]
	
	if coins >= upgr.current_cost:
		coins -= upgr.current_cost
		upgr.level += 1
		upgr.current_cost *= 1.5
		
		apply_upgrade_to_weapon(upgrade_name)
		wealth_changed.emit(coins)
		update_shop_ui()
	else:
		"Not enough gold!"
	
func apply_upgrade_to_weapon(upgrade_name: String):
	var multiplier = upgrades[upgrade_name]["multiplier"]	
	current_weapon[upgrade_name] *= multiplier

			
func update_shop_ui():
	var shop_buttons = get_tree().get_nodes_in_group("shop_buttons")
	
	for upgrade_name in upgrades:
		var upgr = upgrades[upgrade_name]
		
		for btn in shop_buttons:
			if btn.upgrade_type == upgrade_name:
				btn.update_data(upgrade_name, upgr.multiplier, upgr.level, upgr.current_cost)
				
				if not btn.pressed.is_connected(buy_upgrade):
					btn.pressed.connect(buy_upgrade.bind(upgrade_name))
					print("upgrade_name connected")
		
func add_coin(amount: int):
	coins+= amount
	wealth_changed.emit(coins)

	
func take_damage(amount: float):
	current_health -= amount
	health_changed.emit(current_health)
		
	if current_health <= 0:
		health_depleted.emit()
		
		
func die():
	queue_free()
