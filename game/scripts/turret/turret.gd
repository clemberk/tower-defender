extends Area2D

@onready var cannon = $TurretPlatform/Cannon
@onready var current_weapon: Weapon = cannon

signal health_changed(new_value)
signal health_depleted
signal wealth_changed(new_amount)

var max_health: float = 100.0
var current_health: float = 100.0
var coins: int = 0

var upgrades = {
	"damage": {
		"level": 1,
		"base_cost": 50,
		"current_cost": 50
	},
	"fire_rate": {
		"level": 1,
		"base_cost": 10,
		"current_cost": 100
	},
	"crit_chance": {
		"level": 1,
		"base_cost": 75,
		"current_cost": 75
	}
}	
	
func _process(_delta):
	current_weapon.look_at(get_global_mouse_position())
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and current_weapon.can_shoot_atm:
		current_weapon.shoot_projectile()
		
	
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
	else:
		"Not enough gold!"
	
func apply_upgrade_to_weapon(upgrade_name: String):
	match upgrade_name:
		"damage":
			current_weapon.damage_range *= Vector2(1.5, 1.5)
		"fire_rate":
			current_weapon.fire_rate *= 1.5
		"crit_chance":
			current_weapon.crit_chance *= 1.5
		"crit_multiplier":
			current_weapon.crit_multiplier *= 1.5
		
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


func _on_level_up_damage_button_pressed() -> void:
	buy_upgrade("damage")


func _on_level_up_fire_rate_button_pressed() -> void:
	buy_upgrade("fire_rate")


func _on_upgrade_crit_chance_btn_pressed() -> void:
	buy_upgrade("crit_chance") 


func _on_upgrade_crit_multiplier_btn_pressed() -> void:
	buy_upgrade("crit_multiplier")
