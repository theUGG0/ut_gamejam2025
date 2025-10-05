# HorseRace.gd
extends Node2D

# Horse references
@onready var player_horse = $PlayerHorse
@onready var ai_horse1 = $AIHorse1
@onready var ai_horse2 = $AIHorse2
@onready var ai_horse3 = $AIHorse3

# UI references
@onready var instruction_label = $InstructionLabel
@onready var winner_label = $WinnerLabel

# Sound references
@onready var bg_music = $BackgroundMusic
@onready var gallop_sound = $GallopSound
@onready var win_sound = $WinSound
@onready var lose_sound = $LoseSound 

# Finish line position
@onready var finish_line = $FinishLine
var finish_x: float

# Game state
var race_started = false
var race_finished = false
var countdown = 3

# Horse speeds
var player_speed = 35
var ai_speeds = []

# Player scoring
var player_score = 0
var player_score_penalty = 0

func _ready():
	finish_x = finish_line.global_position.x
	winner_label.visible = false
	
	# Play background music
	if bg_music:
		bg_music.play()
	
	# Randomize AI speeds
	ai_speeds = [
		randf_range(2.5, 4.0),
		randf_range(2.5, 4.0),
		randf_range(2.5, 4.0)
	]
	
	_start_countdown()

func _start_countdown():
	instruction_label.text = "Get Ready!"
	await get_tree().create_timer(1.0).timeout
	
	instruction_label.text = "3"
	await get_tree().create_timer(1.0).timeout
	
	instruction_label.text = "2"
	await get_tree().create_timer(1.0).timeout
	
	instruction_label.text = "1"
	await get_tree().create_timer(1.0).timeout
	
	instruction_label.text = "GO! Spam SPACE!"
	race_started = true

func _process(delta):
	if not race_started or race_finished:
		if Input.is_action_just_pressed("race_move"):
			player_score_penalty += 0.2
		return
		
	# Player horse movement
	if Input.is_action_just_pressed("race_move"):

		player_horse.position.x += player_speed
		
		# Play gallop sound
		if gallop_sound:
			gallop_sound.play()
	
	# AI horses move automatically
	ai_horse1.position.x += ai_speeds[0]
	ai_horse2.position.x += ai_speeds[1]
	ai_horse3.position.x += ai_speeds[2]
	
	_check_winners()

func _check_winners():
	var horses = [
		{"name": "You", "horse_obj": player_horse},
		{"name": "Red Horse", "horse_obj": ai_horse1},
		{"name": "Blue Horse", "horse_obj": ai_horse2},
		{"name": "Green Horse", "horse_obj": ai_horse3}
	]
	
	for horse in horses:
		if horse["horse_obj"].position.x >= 1860:
			_race_finished(horses)

func _race_finished(horses: Array):
	race_finished = true
	for checking_horse in horses:
		checking_horse["ranking"] = len(horses.filter(func(horse): return horse["horse_obj"].position.x > checking_horse["horse_obj"].position.x))
	
	var winner_name = null
	
	for horse in horses:
		if horse["ranking"] == 0:
			winner_label.text = "%s won!" % horse["name"]
			winner_name = horse["name"]
		if horse["name"] == "You":
			player_score = int(( 4 - horse["ranking"]) * 10 - min(player_score_penalty, 10))
	
	instruction_label.visible = false
	winner_label.visible = true
	
	# Play win or lose sound based on who won
	if winner_name == "You":
		if win_sound:
			win_sound.play()
	else:
		if lose_sound:
			lose_sound.play()
	
	# Stop background music
	if bg_music:
		bg_music.stop()
	
	
	await get_tree().create_timer(3).timeout
	GameManager.finish_game("horsy race", player_score, "whack_a_mole")
	# await get_tree().create_timer(3.0).timeout
	#get_tree().change_scene_to_file("res://main.tscn")  # Change to your main scene path
