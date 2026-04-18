extends AnimatedEnemy

func _ready():
	type = "Orc Rider"
	speed = 140.0
	max_health = 200.0
	current_health = 300.0
	damage_per_hit = 4.0
	hit_rate = 1.0
	base_coin_drop_amount = 20
	attack_animation_delay = 0.4
	death_animation_delay = 0.0
	attack_sound_path = "res://assets/audio/orc_rider_hit.mp3"
	
	
	scale_enemy(4.0)
	
	super._ready()
	
	if _sprite.texture:
		var sprite_height = _sprite.get_rect().size.y * _sprite.scale.y
		_health_bar.global_position.y -= (sprite_height / 2.0)
		_health_bar.setup(max_health)
