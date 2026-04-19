extends Area2D

class_name AnimatedEnemy

signal defeated

@onready var _health_bar = $HealthBar
@onready var _visuals = $Visuals
@onready var _sprite = $Visuals/Sprite2D
@onready var collision_shape = $CollisionShape2D
@onready var _animation: AnimationPlayer = $Visuals/AnimationPlayer
@onready var _audio: AudioStreamPlayer = $AudioStreamPlayer

@export var damage_number_label = preload("res://scenes/ui_stuff/damage_number_label.tscn")
@export var coin_scene = preload("res://scenes/items/coin.tscn")

@export var type: String = ""
@export var speed: float = 100
@export var max_health: float = 100
@export var current_health: float = max_health
@export var damage_per_hit: float = 2
@export var hit_rate: float = 1
@export var base_coin_drop_amount: int = 1
@export var attack_animation_delay: float = 0.0
@export var attack_sound_path: String = ""
@export var death_animation_delay: float = 0.0
@export var death_sound_path: String = ""

var target = null
var can_attack_atm: bool = true
var stop_distance: float = 100.0
var velocity: Vector2 = Vector2(0.0, 0.0)
var is_dead: bool = false
var is_walking: bool = false


func _ready():
	if _sprite.texture:
		var sprite_height = _sprite.get_rect().size.y * _sprite.scale.y
		_health_bar.global_position.y -= (sprite_height / 2.4)
		_health_bar.setup(max_health)
	
	target = get_tree().current_scene.find_child("Turret", true, false)
	if target == null:
		print("Turret not found")
	
func _process(delta):
	if not target: return
	if is_dead: return
		
	var distance_to_target = global_position.distance_to(target.global_position)
	
	if distance_to_target > stop_distance:
		var direction = (target.global_position - global_position).normalized()
		velocity = direction * speed * delta
		global_position += velocity

		if not _visuals.has_node("AnimationPlayer"):
			_visuals.look_at(target.global_position)
		else:
			if velocity.x < 0:
				_visuals.scale.x = -abs(_visuals.scale.x)
				_visuals.scale.y = -abs(_visuals.scale.y)
			else:
				_visuals.scale.x = abs(_visuals.scale.x)
				
	else:
		velocity = Vector2.ZERO
		if can_attack_atm:
			attack_target()
			
func _physics_process(_delta: float):
	if not target: return
	if is_dead: return
	
	if velocity.x < 0:
		if !_sprite.flip_v:
			_sprite.flip_v = true
	elif velocity.x > 0:
		_sprite.flip_v = false
		
	if _animation.current_animation == "hurt" and _animation.is_playing():
		return
		
	if _animation.current_animation == "attack" and _animation.is_playing():
		return
		
	if velocity != Vector2.ZERO:
		_animation.play("run")
	else:
		if _animation.has_animation("idle"):
			_animation.play("idle")
		else:
			_animation.stop()
		
func scale_enemy(factor:float):
	collision_shape.scale *= factor
	_visuals.scale *= factor
	
func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout
	

			
func attack_target():
	if not is_inside_tree() or is_dead or not can_attack_atm: return
	if _animation.current_animation == "hurt": return
	
	can_attack_atm = false
	
	if _animation.current_animation != "attack":
			_animation.play("attack")
			
	if attack_animation_delay > 0.0:
		await get_tree().create_timer(attack_animation_delay).timeout
		
	if is_dead or _animation.current_animation == "hurt":
		can_attack_atm = true
		return
		
	if not is_dead and target and target.has_method("take_damage"):
		if attack_sound_path != "":
			_audio.stream = load(attack_sound_path)
			_audio.play()
		target.take_damage(damage_per_hit)
		print("Enemy hits turret! Damage: ", damage_per_hit)
		
	var cooldown = max(0.1, hit_rate - attack_animation_delay)
	await get_tree().create_timer(cooldown).timeout
		
	can_attack_atm = true
	
func take_damage(amount: float, is_crit: bool):
	if is_dead: return
	
	current_health -= amount
	_health_bar.update_health(current_health)
	spawn_damage_label(amount, is_crit)
	show_hit_flash(is_crit)
	
	if current_health <= 0:
		die()
	else:
		_animation.play("hurt")
		
		
func show_hit_flash(is_crit: bool):
	var tween = create_tween()
	var flash_color = Color.WHITE
	
	if is_crit:
		flash_color = Color.FIREBRICK
		
	modulate = flash_color * 2.0
	
	tween.tween_property(self, "modulate", Color.WHITE, 0.1).set_trans(Tween.TRANS_SINE)
	
	
func spawn_damage_label(amount: float, is_crit: bool):
	var damage_label = damage_number_label.instantiate()
	get_tree().current_scene.add_child(damage_label)
	
	# randomize number position a little bit
	var label_position = global_position + Vector2(randf_range(-5,5), randf_range(-5,5))
	damage_label.display_damage_number(amount, label_position, is_crit)
	
func drop_coin(pos: Vector2):
	var coin = coin_scene.instantiate()
	coin.global_position = pos
	get_tree().current_scene.add_child(coin)
	
	
func die():
	if is_dead: return
	is_dead = true
	velocity = Vector2.ZERO
	
	defeated.emit()
	
	collision_shape.set_deferred("disabled", true)
	_health_bar.hide()
	
	_animation.play("die")
	
	if death_sound_path != "":
		_audio.stream = load(death_sound_path)
		_audio.play()
		
	if death_animation_delay > 0.0:
		await get_tree().create_timer(death_animation_delay).timeout
	
	for i in range(base_coin_drop_amount):
		drop_coin.call_deferred(global_position)
		
	if get_tree().current_scene.has_method("_on_enemy_killed"):
		get_tree().current_scene._on_enemy_killed(type)
		
	if _animation.is_playing():
		await _animation.animation_finished
		
	start_corpse_fading()
		
func start_corpse_fading():
	var tween = create_tween()
	
	var stay_time = randf_range(3.0, 5.0)
	
	tween.tween_interval(stay_time)
	tween.tween_property(self, "modulate:a", 0.0, 2.0)
	
	tween.finished.connect(queue_free)
		
