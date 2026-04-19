extends Camera2D

@onready var turret: Area2D = get_tree().get_current_scene().get_node("Turret")

@export var camera_speed: float = 600.0
@export var camera_return_speed: float = 5.0
var arena_size: Vector2 = Vector2(2000, 2000)

func _ready():
	global_position = Vector2.ZERO
	
func _process(delta: float):
	handle_camera_movement(delta)
	
func handle_camera_movement(delta: float):
	var input_direction = Vector2.ZERO
	
	if Input.is_action_pressed("camera_up"): input_direction.y -= 1
	if Input.is_action_pressed("camera_down"): input_direction.y += 1
	if Input.is_action_pressed("camera_left"): input_direction.x -= 1
	if Input.is_action_pressed("camera_right"): input_direction.x += 1
	if Input.is_action_pressed("camera_center"): global_position = turret.global_position
		
	
	if input_direction != Vector2.ZERO:
		global_position += input_direction.normalized() * camera_speed * delta
		
		global_position.x = clamp(global_position.x, -arena_size.x/2, arena_size.x/2)
		global_position.y = clamp(global_position.y, -arena_size.y/2, arena_size.y/2)
		
		
