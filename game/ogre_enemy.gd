extends Enemy

func _ready():
	scale = Vector2(1.0, 1.0)
	max_health = 200
	current_health = 200
	speed = 50
	damage_per_hit = 10
	hit_rate = 1
	
	# run _ready function of parent class
	super._ready()
