extends Node2D

@onready var turret_platform = $TurretPlatform

func _ready():
	center_turret()
	get_viewport().size_changed.connect(center_turret)
	randomize() # every new game should start with different rolls
	

func center_turret():
	var viewport_size = get_viewport_rect().size
	turret_platform.position = viewport_size / 2
