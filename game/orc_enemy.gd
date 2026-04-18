extends AnimatedEnemy

func _ready():
	type = "Orc"
	scale_enemy(4.0)
	max_health = 150.0
	current_health = 150.0
	speed = 80.0
	damage_per_hit = 2.0
	hit_rate = 0.8
	attack_animation_delay = 0.4
	base_coin_drop_amount = 8
	attack_sound_path = "res://assets/audio/orc_hit.mp3"
	
	# run _ready function of parent class
	super._ready()
