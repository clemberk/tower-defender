extends Panel

func _input(event):
	if event.is_action_pressed("open_shop"):
		print("Shop geöffnet")
		var focus_owner = get_viewport().gui_get_focus_owner()
		print(focus_owner)
		if focus_owner is LineEdit:
			return
			
		toggle_shop()
		
		
func toggle_shop():
	visible = !visible
	get_tree().paused = visible
