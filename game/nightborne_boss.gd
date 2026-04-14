extends Enemy

signal defeated

@onready var _animation: AnimationPlayer = $Visuals/AnimationPlayer
@onready var _sprite = $Visuals/Sprite2D
var is_dead: bool = false


func _ready():
	type = "Nightborne"
	scale_enemy(10.0)
	max_health = 1000.0
	current_health = 1000.0
	speed = 50.0
	damage_per_hit = 20.0
	hit_rate = 2.0
	base_coin_drop_amount = 100
	
	# run _ready function of parent class
	super._ready()
	
func _physics_process(_delta: float):
	if is_dead: return
	
	if velocity.x < 0:
		if !_sprite.flip_v:
			_sprite.flip_v = true
	elif velocity.x > 0:
		_sprite.flip_v = false
		
	if _animation.current_animation == "hurt" and _animation.is_playing():
		return
		
	if is_attacking:
		if _animation.current_animation!= "attack":
			_animation.play("attack")
	elif is_walking:
		_animation.play("run")
	
func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout
			
func take_damage(amount: float, is_crit: bool):
	if is_dead: return
	
	current_health -= amount
	health_bar.update_health(current_health)
	spawn_damage_label(amount, is_crit)
	show_hit_flash(is_crit)
	
	if current_health <= 0:
		die()
	else:
		_animation.play("hurt")

		
func die():
	if is_dead: return
	defeated.emit()
	is_dead = true
	
	collision_shape.set_deferred("disabled", true)
	_animation.play("die")
	_audio.stream = load("res://assets/audio/nightborne_dying.mp3")
	_audio.play()
	
	await get_tree().create_timer(1.3).timeout
	
	for i in range(base_coin_drop_amount):
		drop_coin.call_deferred(global_position)
	if get_tree().current_scene.has_method("_on_enemy_killed"):
		get_tree().current_scene._on_enemy_killed(type)
		
	if _animation.is_playing():
		await _animation.animation_finished
		
	queue_free()
