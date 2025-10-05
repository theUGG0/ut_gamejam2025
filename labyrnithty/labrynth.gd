extends Node2D

var score := 0
var game_time := 40.0
var game_over := false
var player_prize = null
func _ready():
	$tegelane/Camera2D/CanvasLayer/Score.text = "Score: %d" % score
	$tegelane/Camera2D/CanvasLayer/Timer.text = "Time: %d" % int(game_time)
	$tegelane/Camera2D/CanvasLayer/EndMessage.text = ""

	# Connect all coins
	for coin in $Coins.get_children():
		if coin.has_signal("collected"):
			coin.collected.connect(_on_coin_collected)
	
	$theExit.body_entered.connect(_on_exit_reached)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if game_over:
		return
	
	game_time -= delta
	if game_time <= 0:
		game_time = 0
		game_over = true
		$tegelane/Camera2D/CanvasLayer/EndMessage.text = "Too bad, try again!"

		GameManager.finish_game("maze", 0)


	$tegelane/Camera2D/CanvasLayer/Timer.text = "Time: %d" % int(game_time)


func _on_coin_collected():
	if game_over:
		return
	score += 1
	$tegelane/Camera2D/CanvasLayer/Score.text = "Score: %d" % score

func _on_exit_reached(body: Node):
	if game_over:
		return
	if body is CharacterBody2D:
		game_over = true
		$tegelane/Camera2D/CanvasLayer/EndMessage.text = "Congrats! Score: %d" % score

		if score < 4:
			player_prize = "laburint_small"
		elif score <= 6:
			player_prize = "laburint_big"
		GameManager.finish_game("Maze", score, player_prize)
