extends Control

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_highscore_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui_stuff/highscore_table.tscn")
