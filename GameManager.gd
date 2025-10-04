extends Node

var game_scores: Dictionary = {}
var toys: Array = ["whack_a_mole"]
var player_spawn_pos: Vector2 = Vector2(0, 2)

var toy_textures = {
	"whack_a_mole": preload("res://asstes/minon.png")
}

var toy_names = {
	"whack_a_mole": "Minion Bob"
}

signal score_changed(game_name: String, game_score: int)
signal added_toy(toy_name: String)
signal _display_game_start_dialogue(game_name: String, game_scene_path: String)
signal _hide_game_start_dialogue()
signal _display_game_finish_dialogue(score: int, toy_id: String)

# changes the score of a game in the game_scores directory to new_score
func insert_game_score(game_name: String, new_score: int):
	game_scores[game_name] = new_score
	emit_signal("score_changed", game_name, game_scores[game_name])

# increases the score of a game in the game_scores directory by score_change
func upsert_game_score(game_name: String, score_change: int):
	if not game_scores.has(game_name):
		game_scores[game_name] = 0
	game_scores[game_name] += score_change
	emit_signal("score_changed", game_name, game_scores[game_name])

# returns the sum of all games in game_scores
func get_total_score():
	if game_scores.is_empty():
		return 0
	var total = 0
	for v in game_scores.values():
		total += v
	return total

func _give_toy(toy_name: String):
	if toys.has(toy_name):
		emit_signal("player_has_toy", toy_name)
		return
	toys.append(toy_name)
	emit_signal("added_toy", toy_name)

func finish_game(game_name: String, score: int, toy_id=null):
	get_tree().change_scene_to_file("res://scenes/main.tscn")
	emit_signal("_display_game_finish_dialogue", score, toy_id)
	
func display_game_start_dialogue(game_name: String, game_scene_path: String):
	print(player_spawn_pos)
	emit_signal("_display_game_start_dialogue", game_name, game_scene_path)

func hide_game_start_dialogue():
	emit_signal("_hide_game_start_dialogue")
