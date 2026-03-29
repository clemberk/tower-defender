extends Enemy

func _ready():
	# run _ready function of parent class
	super._ready()
	
	scale = Vector2(0.75, 0.75)
	health = 100.0
	speed = 100.0
	damage_per_hit = 2.0
	hit_rate = 1.0
