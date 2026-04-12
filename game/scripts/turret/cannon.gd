extends Sprite2D

@export var cannon_ball_scene = preload("res://cannon_ball.tscn")

var can_shoot_atm: bool = true

func _process(_delta):
	look_at(get_global_mouse_position())
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and can_shoot_atm:
		shoot()
		
func shoot():
	var projectile = cannon_ball_scene.instantiate()
	get_tree().current_scene.add_child(projectile)
	
	projectile.global_position = global_position
	projectile.global_rotation = global_rotation
	
	can_shoot_atm = false
	
	await get_tree().create_timer(1.0 / projectile.fire_rate).timeout
	can_shoot_atm = true
