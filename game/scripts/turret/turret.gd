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
		"max_level": 50,
		"current_cost": 40,
		"start_value": 1.0,
		"max_value": 1.0
	},
	"fire_rate": {
		"level": 1,
		"max_level": 50,
		"current_cost": 80,
		"start_value": 1.0,
		"max_value": 1.0
	},
	"crit_chance": {
		"level": 1,
		"max_level": 50,
		"current_cost": 70,
		"start_value": 1.0,
		"max_value": 1.0
		
	},
	"crit_multiplier": {
		"level": 1,
		"max_level": 50,
		"current_cost": 70,
		"start_value": 1.0,
		"max_value": 1.0
	}
}	

func _ready():
	upgrades.damage.start_value = current_weapon.damage_multiplier
	upgrades.fire_rate.start_value = current_weapon.fire_rate
	upgrades.crit_chance.start_value = current_weapon.crit_chance
	upgrades.crit_multiplier.start_value = current_weapon.crit_multiplier
	
	upgrades.damage.max_value = current_weapon.damage_multiplier * 20.0
	upgrades.fire_rate.max_value = current_weapon.fire_rate * 10.0
	upgrades.crit_chance.max_value = 95.0
	upgrades.crit_multiplier.max_value = 500.0
	
	update_shop_ui()
	audio_player.stream = load("res://assets/audio/cannon_shooting.mp3")
	
func _process(_delta):
	current_weapon.look_at(get_global_mouse_position())
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and current_weapon.can_shoot_atm:
		current_weapon.shoot_projectile()
		audio_player.play()
		
	
func calculate_asymptotic_value(upgrade_name: String) -> float:
	var upgr = upgrades[upgrade_name]
	var level = float(upgr.level)
	var max_l = float(upgr.max_level)
	
	var t = (level - 1.0) / (max_l - 1.0)
	var curve = pow(t, 0.98) 
	
	return lerp(upgr.start_value, upgr.max_value, curve)
	
	
func buy_upgrade(upgrade_name: String):
	if not upgrades.has(upgrade_name):
		return
		
	var upgr = upgrades[upgrade_name]
	
	if upgr.level >= upgr.max_level:
		print("Max Level reached!")
		return
		
	
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
	var new_value = calculate_asymptotic_value(upgrade_name)
	
	if upgrade_name == "damage":
		current_weapon.damage_multiplier = new_value
	else:
		current_weapon[upgrade_name] = new_value
	
	print(upgrade_name, " upgraded to: ", snapped(new_value, 0.01))

			
func update_shop_ui():
	var shop_buttons = get_tree().get_nodes_in_group("shop_buttons")
	
	for upgrade_name in upgrades:
		var upgr = upgrades[upgrade_name]
		
		var current_val = calculate_asymptotic_value(upgrade_name)
		var next_val = current_val
		if upgr.level < upgr.max_level:
			upgr.level += 1
			next_val = calculate_asymptotic_value(upgrade_name)
			upgr.level -= 1 
		
		for btn in shop_buttons:
			if btn.upgrade_type == upgrade_name:
				btn.update_data(upgrade_name, next_val, upgr.level, upgr.current_cost)
				
				if upgr.level >= upgr.max_level:
					btn.disabled = true
				
				if not btn.pressed.is_connected(buy_upgrade):
					btn.pressed.connect(buy_upgrade.bind(upgrade_name))
		
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
