extends Projectile

func _ready():
	scale = Vector2(0.5, 0.5)
	speed = 500
	fire_rate = 3
	damage_range = Vector2(30, 80)
	crit_chance = 10
	crit_multiplier = 100
	

func execute_hit():
	super.execute_hit()
