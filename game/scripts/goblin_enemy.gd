extends Enemy

func _ready():
	# run _ready function of parent class
	super._ready()
	
	scale = Vector2(1.0, 1.0)
	health = 10.0
	speed = 100.0
	damage_per_hit = 2.0
	hit_rate = 1.0
