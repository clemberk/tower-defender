extends Projectile

func _ready():
	scale = Vector2(0.5, 0.5)
	fire_rate = 2
	speed = 500
	damage = 2
	

func execute_hit():
	print("Hit!")
	super.execute_hit()
