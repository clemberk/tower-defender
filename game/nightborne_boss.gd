extends AnimatedEnemy

func _ready():
	type = "Nightborne"
	scale_enemy(8.0)
	max_health = 4000.0
	current_health = 4000.0
	speed = 80.0
	damage_per_hit = 20.0
	hit_rate = 2.0
	base_coin_drop_amount = 100
	attack_animation_delay = 0.9
	attack_sound_path = "res://assets/audio/nightborne_hit.mp3"
	death_animation_delay = 1.3
	death_sound_path = "res://assets/audio/nightborne_dying.mp3"
	
	# run _ready function of parent class
	super._ready()
	
