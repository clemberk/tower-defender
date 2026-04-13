extends Projectile

func _ready():
	scale = Vector2(0.5, 0.5)
	speed = 500
	
	

func execute_hit():
	super.execute_hit()
