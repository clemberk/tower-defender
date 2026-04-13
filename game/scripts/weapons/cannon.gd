extends Weapon

@export var cannon_ball_scene = preload("res://cannon_ball.tscn")

func _ready():
	fire_rate = 3
	damage_range = Vector2(30, 80)
	crit_chance = 10
	crit_multiplier = 100
	projectile_scene = cannon_ball_scene
