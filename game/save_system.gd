extends Node

const SAVE_PATH = "user://highscores.json"

var highscores: Array = []

func _ready():
	load_scores()
	
func load_scores():
	if not FileAccess.file_exists(SAVE_PATH):
		return
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var content = file.get_as_text()
	highscores = JSON.parse_string(content)
	
func save_scores():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	var json_string = JSON.stringify(highscores)
	file.store_string(json_string)
	
func add_highscore(player_name: String, score: int):
	highscores.append({
		"name": player_name, 
		"score": int(score)
		})
	highscores.sort_custom(func(a,b): return a["score"] > b["score"])
	
	if highscores.size() > 10:
		highscores.resize(10)
	
	save_scores()
	
func is_new_highscore(score: int):
	if highscores.size() < 10: return true
	return score > highscores.back()["score"]
