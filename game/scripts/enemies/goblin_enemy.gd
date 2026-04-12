extends Enemy

func _ready():
	scale = Vector2(0.75, 0.75)
	max_health = 100
	current_health = 100
	speed = 100
	damage_per_hit = 2
	hit_rate = 1
	base_coin_drop_amount = 5
	
	# run _ready function of parent class
	super._ready()
