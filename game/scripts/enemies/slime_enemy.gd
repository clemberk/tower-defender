extends AnimatedEnemy

func _ready():
	type = "Slime"
	scale_enemy(4.0)
	max_health = 200.0
	current_health = 200.0
	speed = 50.0
	damage_per_hit = 3.0
	hit_rate = 0.8
	attack_animation_delay = 0.4
	base_coin_drop_amount = 10
	attack_sound_path = "res://assets/audio/orc_hit.mp3"
	
	# run _ready function of parent class
	super._ready()
