extends Node

var game_scores: Dictionary = {}
var toys: Array = []

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

# returns the sum of all game scores in game_scores
func get_total_score():
	if game_scores.is_empty():
		return 0
	var total = 0
	for v in game_scores.values():
		total += v
	return total

func give_toy(toy_name: String):
	if toys.has(toy_name):
		emit_signal("player_has_toy", toy_name)
		return
	toys.append(toy_name)
	emit_signal("added_toy", toy_name)
