extends Projectile

func _ready():
	scale = Vector2(0.5, 0.5)
	speed = 500
	fire_rate = 5.0
	damage_range = Vector2(10.0,20.0)
	crit_chance = 5.0
	crit_multiplier = 20.0
	

func execute_hit():
	super.execute_hit()
