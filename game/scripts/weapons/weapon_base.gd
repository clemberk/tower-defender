extends Node
class_name Weapon

@export var fire_rate: float = 0.0
@export var damage: Vector2 = Vector2(0.0, 0.0)
@export var damage_multiplier = 1.0
@export var crit_chance: float = 0.0
@export var crit_multiplier: float = 0.0
@export var projectile_scene: PackedScene
@export var can_shoot_atm: bool = true

@export var animation_player: AnimationPlayer
@export var muzzle: Node2D

func shoot_projectile():
	play_fire_animation()
	var projectile = projectile_scene.instantiate()
	
	projectile.damage = self.damage
	projectile.damage_multiplier = self.damage_multiplier
	projectile.crit_chance = self.crit_chance
	projectile.crit_multiplier = self.crit_multiplier
	
	get_tree().current_scene.add_child(projectile)
	
	if muzzle:
		projectile.global_position = muzzle.global_position
		projectile.global_rotation = muzzle.global_rotation
	else:
		projectile.global_position = self.global_position
		projectile.global_rotation = self.global_rotation
		
	can_shoot_atm = false
	
	await get_tree().create_timer(1.0 / fire_rate).timeout
	can_shoot_atm = true

func play_fire_animation():
	if animation_player and animation_player.has_animation("shoot"):
		var anim = animation_player.get_animation("shoot")
		var anim_length = anim.length
		
		var time_between_shots = 1.0 / fire_rate
		
		animation_player.speed_scale = anim_length / time_between_shots *2
		animation_player.play("shoot")
