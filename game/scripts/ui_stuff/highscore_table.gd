extends CanvasLayer

func _ready():
	update_highscore_table()
	
func update_highscore_table():
	var list_container = $HighscoreList
	
	for row in list_container.get_children():
		row.queue_free()
		
	var highscores = SaveSystem.highscores
	
	for i in range(highscores.size()):
		var entry = highscores[i]
		
		var row = HBoxContainer.new()
		row.add_theme_constant_override("separation", 50)
		row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		
		var name_label = Label.new()
		name_label.text = str(i + 1) + ". " + entry["name"]
		name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		
		var score_label = Label.new()
		score_label.text = str(int(entry["score"]))
		score_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		
		row.add_child(name_label)
		row.add_child(score_label)
		list_container.add_child(row)


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui_stuff/main_menu.tscn")
