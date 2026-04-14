extends Weapon

@export var cannon_ball_scene = preload("res://cannon_ball.tscn")

func _ready():
	fire_rate = 3.0
	damage_range = Vector2(50.0, 80.0)
	crit_chance = 10.0
	crit_multiplier = 100.0
	projectile_scene = cannon_ball_scene
