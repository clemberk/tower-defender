extends Enemy

func _ready():
	type = "Goblin"
	scale_enemy(0.75)
	max_health = 100.0
	current_health = 100.0
	speed = 100.0
	damage_per_hit = 2.0
	hit_rate = 1.0
	base_coin_drop_amount = 5
	
	# run _ready function of parent class
	super._ready()
