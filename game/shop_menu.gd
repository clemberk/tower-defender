extends Panel

func _input(event):
	if event.is_action_pressed("open_shop"):
		toggle_shop()

func toggle_shop():
	visible = !visible
	get_tree().paused = visible
