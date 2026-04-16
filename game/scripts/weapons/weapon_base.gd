extends Node
class_name Weapon

@export var fire_rate: float = 0.0
@export var damage: Vector2 = Vector2(0.0, 0.0)
@export var crit_chance: float = 0.0
@export var crit_multiplier: float = 0.0
@export var projectile_scene: PackedScene
@export var can_shoot_atm: bool = true

func shoot_projectile():
	var projectile = projectile_scene.instantiate()
	
	projectile.damage = self.damage
	projectile.crit_chance = self.crit_chance
	projectile.crit_multiplier = self.crit_multiplier
	
	get_tree().current_scene.add_child(projectile)
	
	projectile.global_position = self.global_position
	projectile.global_rotation = self.global_rotation
	
	can_shoot_atm = false
	
	await get_tree().create_timer(1.0 / fire_rate).timeout
	can_shoot_atm = true
