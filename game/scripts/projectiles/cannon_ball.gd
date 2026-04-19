extends Projectile

@onready var sprite = $Sprite2D

func _ready():
	scale = Vector2(2.0, 2.0)
	speed = 500
	
	
func _process(delta: float):
	super._process(delta)
	
	if sprite:
		sprite.rotation += 10.0 * delta
	

func execute_hit():
	super.execute_hit()
