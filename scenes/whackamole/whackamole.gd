extends Node2D

var score := 0
var game_time := 30.0
var game_over := false

@export var music_file: AudioStream  

@onready var music_player = AudioStreamPlayer.new()

func _ready():
	$CanvasLayer/Score_.text = "Score: %d" % score
	$CanvasLayer/Timer_.text = "Time: %d" % int(game_time)

	$Mole.mole_hit.connect(_on_mole_hit)
	add_child(music_player)
	music_player.stream = music_file
	music_player.play()

func _process(delta: float) -> void:
	if game_over:
		return

	game_time -= delta
	if game_time <= 0:
		game_time = 0
		game_over = true
		$CanvasLayer/Finale.text = "Score: %d" % score
		await get_tree().create_timer(3).timeout
		
		var prize = null
		if score < 20:
			prize = "whack_a_mole_small"
		else:
			prize = "whack_a_mole_big"
		
		music_player.stop()
		GameManager.finish_game("whack_a_mole", score, prize)
		
	
	$CanvasLayer/Timer_.text = "Time: %d" % int(game_time)

func _on_mole_hit():
	if game_over:
		return
	score += 1
	$CanvasLayer/Score_.text = "Score: %d" % score
