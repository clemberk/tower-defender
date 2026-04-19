extends AnimatedEnemy

func _ready():
	type = "Armored Lumberjack"
	scale_enemy(4.0)
	max_health = 500.0
	current_health = 500.0
	speed = 40.0
	damage_per_hit = 10.0
	hit_rate = 1.2
	attack_animation_delay = 0.4
	base_coin_drop_amount = 35
	attack_sound_path = "res://assets/audio/orc_hit.mp3"
	
	# run _ready function of parent class
	super._ready()
