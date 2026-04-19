extends Enemy

func _ready():
	type = "Ogre"
	scale_enemy(1.0)
	max_health = 200.0
	current_health = 200.0
	speed = 50.0
	damage_per_hit = 10.0
	hit_rate = 1.0
	base_coin_drop_amount = 10
	
	# run _ready function of parent class
	super._ready()
