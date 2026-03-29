extends Projectile

func _ready():
	scale = Vector2(0.5, 0.5)
	fire_rate = 2.0
	speed = 500
	damage = 25.0
	

func execute_hit():
	print("Hit!")
	super.execute_hit()
