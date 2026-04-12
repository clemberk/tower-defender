extends Label

func display_damage_number(amount: float, pos: Vector2, is_crit: bool):
	text = str(amount)
	global_position = pos
	
	var tween = create_tween()
	
	if is_crit:
		self.set("theme_override_colors/font_color", Color.FIREBRICK)
		self.set("theme_override_font_sizes/font_size", 32)
		
		for i in range(4):
			var shake_offset = Vector2(randf_range(-10, 10), randf_range(-10,10))
			tween.tween_property(self, "position", pos + shake_offset, 0.08)
			tween.parallel().tween_property(self, "rotation", randf_range(-0.2, 0.2), 0.05)
			
		tween.tween_property(self, "rotation", 0, 0.05)
		tween.tween_property(self, "position", pos, 0.05)
		
	tween.tween_property(self, "global_position:y", global_position.y - 30, 1.0).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(self, "modulate:a", 0.0, 1.0)
	
	tween.finished.connect(queue_free)
