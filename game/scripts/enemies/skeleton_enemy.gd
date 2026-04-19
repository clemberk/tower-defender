extends AnimatedEnemy

func _ready():
	type = "Skeleton"
	scale_enemy(4.0)
	max_health = 150.0
	current_health = 150.0
	speed = 100.0
	damage_per_hit = 4.0
	hit_rate = 1.0
	attack_animation_delay = 0.4
	base_coin_drop_amount = 15
	attack_sound_path = "res://assets/audio/orc_hit.mp3"
	
	# run _ready function of parent class
	super._ready()
