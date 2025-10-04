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

# Finish line position
@onready var finish_line = $FinishLine
var finish_x: float

# Game state
var race_started = false
var race_finished = false
var countdown = 3

# Horse speeds (pixels per key press for player, auto speed for AI)
var player_speed = 35  # How much player moves per spacebar press
var ai_speeds = []  # Random speeds for each AI horse

func _ready():
	finish_x = finish_line.global_position.x
	winner_label.visible = false
	
	# Randomize AI speeds (slightly different for each horse)
	ai_speeds = [
		randf_range(2.5, 4.0),  # AI Horse 1 speed per frame
		randf_range(2.5, 4.0),  # AI Horse 2 speed per frame
		randf_range(2.5, 4.0)   # AI Horse 3 speed per frame
	]
	
	# Start countdown
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
		return
	
	# Player horse movement
	if Input.is_action_just_pressed("race_move"):  # Changed to action_pressed (not just_pressed)
		print("SPACE PRESSED! Moving player horse")
		player_horse.position.x += player_speed
	
	# AI horses move automatically
	ai_horse1.position.x += ai_speeds[0]
	ai_horse2.position.x += ai_speeds[1]
	ai_horse3.position.x += ai_speeds[2]
	
	_check_winners()

func _check_winners():
	var horses = [
		{"name": "You", "horse": player_horse},
		{"name": "Red Horse", "horse": ai_horse1},
		{"name": "Blue Horse", "horse": ai_horse2},
		{"name": "Green Horse", "horse": ai_horse3}
	]
	
	for horse_data in horses:
		if horse_data.horse.global_position.x >= finish_x:
			_race_finished(horse_data.name)
			return

func _race_finished(winner_name: String):
	race_finished = true
	instruction_label.visible = false
	winner_label.visible = true
	winner_label.text = winner_name + " WON!"

	# Wait 3 seconds then return to main scene
	await get_tree().create_timer(3.0).timeout
	get_tree().change_scene_to_file("res://main.tscn")  # Change to your main scene path
