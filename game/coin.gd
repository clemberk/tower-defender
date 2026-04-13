extends Area2D

@onready var _animated_sprite = $AnimatedSprite2D

var velocity: Vector2 = Vector2.ZERO
var gravitation_strength: float = 600.0
var max_gravitation_strength: float = 1800.00
var friction: float = 0.99
var target = null

func _ready():
	_animated_sprite.play("rotate")
	area_entered.connect(_on_area_entered)
	
	target = get_tree().current_scene.find_child("Turret", true, false)
	launch_coin()
	
func _process(delta: float):
	if target:
		var direction_to_turret = (target.global_position - global_position).normalized()
		gravitation_strength = move_toward(gravitation_strength, max_gravitation_strength, 800 * delta)
		velocity += direction_to_turret * gravitation_strength * delta
		velocity *= friction 
		global_position += velocity * delta
	
func launch_coin():
	var random_angle = deg_to_rad(randf_range(-180, 180))
	var force = randf_range(300, 600)
	velocity = Vector2.from_angle(random_angle) * force
	
func _on_area_entered(area):
	if area.name == "Turret" or area.has_method("add_coin"):
		area.add_coin(1)
		queue_free()
