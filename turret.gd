extends Sprite2D

# var projectile_scene = preload("res://projectile.tscn")

func _process(delta):
	look_at(get_global_mouse_position())
	
	if Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		shoot()
		
func shoot():
	print("Shoot")
