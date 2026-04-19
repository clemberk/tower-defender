extends AnimatedEnemy

func _ready():
	type = "Armored Orc"
	scale_enemy(4.0)
	max_health = 400.0
	current_health = 400.0
	speed = 40.0
	damage_per_hit = 8.0
	hit_rate = 0.5
	attack_animation_delay = 0.4
	base_coin_drop_amount = 30
	attack_sound_path = "res://assets/audio/orc_hit.mp3"
	
	# run _ready function of parent class
	super._ready()
