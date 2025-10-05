extends Node

var preloaded_scenes: Dictionary = {}
var tutorial_not_shown = true

var game_scores: Dictionary = {}
var toys: Array = []
var player_spawn_pos: Vector2 = Vector2(0, 2)

var toy_textures = {
	"horse_race_big": preload("res://asstes/toys/big/horse_race_big.png"),
	"flappy_bird_big": preload("res://asstes/toys/big/flappy_bird_big.png"),
	"tight_rope_big": preload("res://asstes/toys/big/tight_rope_big.png"),
	"laburint_big": preload("res://asstes/toys/big/laburint_big.png"),
	"whack_a_mole_big": preload("res://asstes/toys/big/whack_a_mole_big.png"),
	"horse_race_small": preload("res://asstes/toys/small/horse_race_small.png"),
	"flappy_bird_small": preload("res://asstes/toys/small/flappy_bird_small.png"),
	"tight_rope_small": preload("res://asstes/toys/small/tight_rope_small.png"),
	"laburint_small": preload("res://asstes/toys/small/laburint_small.png"),
	"whack_a_mole_small": preload("res://asstes/toys/small/whack_a_mole_small.png")
}

var toy_names = {
	"horse_race_big": "Golden Freddy",
	"flappy_bird_big": "Trixie",
	"tight_rope_big": "Avocado",
	"laburint_big": "Chocolate Cookie",
	"whack_a_mole_big": "Strawberry Shortcake",
	"horse_race_small": "Dotty",
	"flappy_bird_small": "Teddy",
	"tight_rope_small": "One-Eye Joe",
	"laburint_small": "Bubbles",
	"whack_a_mole_small": "Ladybug"
}

signal score_changed(game_name: String, game_score: int)
signal added_toy(toy_name: String)
signal _display_game_start_dialogue(game_name: String, game_scene_path: String)
signal _hide_game_start_dialogue()
signal _hide_game_finish_dialogue()
signal _display_game_finish_dialogue(score: int, toy_id: String)

func _ready() -> void:
	preloaded_scenes["main"] = preload("res://scenes/main.tscn")
	#for toy_id in toy_names.keys():
	#	toys.append(toy_id)

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

func _give_toy(toy_name):
	if toys.has(toy_name) or not toy_name:
		return
	toys.append(toy_name)
	emit_signal("added_toy", toy_name)

func finish_game(game_name: String, score: int, toy_id=null):
	
	_give_toy(toy_id)
	insert_game_score(game_name, score)
	
	var tree = get_tree()
	
	tree.change_scene_to_packed(preloaded_scenes["main"])
	
	await tree.process_frame
	await tree.process_frame

	emit_signal("_hide_game_start_dialogue")
	emit_signal("_display_game_finish_dialogue", score, toy_id)
	
func display_game_start_dialogue(game_name: String, game_scene_path: String):
	emit_signal("_display_game_start_dialogue", game_name, game_scene_path)

func hide_game_start_dialogue():
	emit_signal("_hide_game_start_dialogue")
	emit_signal("_hide_game_finish_dialogue")
