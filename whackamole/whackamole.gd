extends Node2D

var score := 0
var game_time := 60.0
var game_over := false

func _ready():
	$CanvasLayer/Score_.text = "Score: %d" % score
	$CanvasLayer/Timer_.text = "Time: %d" % int(game_time)

	$Mole.mole_hit.connect(_on_mole_hit)

func _process(delta: float) -> void:
	if game_over:
		return

	game_time -= delta
	if game_time <= 0:
		game_time = 0
		game_over = true
		$CanvasLayer/Finale.text = "Score: %d" % score
	
	$CanvasLayer/Timer_.text = "Time: %d" % int(game_time)

func _on_mole_hit():
	if game_over:
		return
	score += 1
	$CanvasLayer/Score_.text = "Score: %d" % score
