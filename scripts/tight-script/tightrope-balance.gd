extends Node2D

# Balance variables
var balance = 0.0  # -100 to 100, 0 is centered
var balance_speed = 30.0  # How fast balance shifts when pressing keys
var auto_drift_speed = 15.0  # Natural drift toward falling
var max_balance = 100.0
var fall_threshold = 85.0  # Fall if balance exceeds this

# Game state
var game_active = true
var time_survived = 0.0
var high_score = 0.0

# Difficulty (increases over time)
var difficulty_multiplier = 1.0

# References
@onready var player = $Player
@onready var rope = $Rope
@onready var balance_bar = $UI/BalanceBar
@onready var balance_indicator = $UI/BalanceBar/Indicator
@onready var timer_label = $UI/TimerLabel
@onready var game_over_label = $UI/GameOverLabel
@onready var instructions_label = $UI/InstructionsLabel

@export var music_file: AudioStream  # Drag your music file here in Inspector

@onready var music_player = AudioStreamPlayer.new()

func _ready():
	setup_game()
	game_over_label.visible = false
	add_child(music_player)
	music_player.stream = music_file
	music_player.play()


func setup_game():
	# Setup balance bar anchors and position
	balance_bar.anchor_left = 0.5
	balance_bar.anchor_right = 0.5
	balance_bar.anchor_top = 0.0
	balance_bar.anchor_bottom = 0.0
	balance_bar.offset_left = -300  # Half of 600px width
	balance_bar.offset_right = 300
	balance_bar.offset_top = 100
	balance_bar.offset_bottom = 140
	
	# Setup indicator to be centered in the bar
	balance_indicator.anchor_left = 0.5
	balance_indicator.anchor_right = 0.5
	balance_indicator.offset_left = -10  # Half of 20px width
	balance_indicator.offset_right = 10
	balance_indicator.offset_top = -5
	balance_indicator.offset_bottom = 45
	
	# Don't move anything - leave player and rope where you positioned them in the scene
	
	# Setup other UI
	timer_label.position = Vector2(40, 40)
	instructions_label.position = Vector2(960, 250)
	game_over_label.position = Vector2(960, 540)

func _process(delta):
	if not game_active:
		return  # Game over, just stop
	
	# Update timer
	time_survived += delta
	timer_label.text = "Time: %.1f s" % time_survived
	
	# Increase difficulty over time
	difficulty_multiplier = 1.0 + (time_survived * 0.05)
	
	# Handle input
	var input_direction = 0.0
	if Input.is_action_pressed("ui_left") or Input.is_key_pressed(KEY_A):
		input_direction = -1.0
	elif Input.is_action_pressed("ui_right") or Input.is_key_pressed(KEY_D):
		input_direction = 1.0
	
	# Apply player input to balance
	if input_direction != 0.0:
		balance += input_direction * balance_speed * delta
	
	# Natural drift (makes it harder - balance wants to tip over)
	var drift_direction = sign(balance) if balance != 0 else (1 if randf() > 0.5 else -1)
	balance += drift_direction * auto_drift_speed * difficulty_multiplier * delta
	
	# Clamp balance
	balance = clamp(balance, -max_balance, max_balance)
	
	# Check for falling
	if abs(balance) > fall_threshold:
		game_over()
		return
	
	# Update visuals
	update_player_tilt()
	update_balance_ui()

func update_player_tilt():
	# Only tilt player based on balance - don't move position
	player.rotation = deg_to_rad(balance * 0.3)

func update_balance_ui():
	# Update balance indicator position (offset from center)
	var indicator_offset = (balance / max_balance) * 300  # 300 is half bar width
	balance_indicator.offset_left = indicator_offset - 10
	balance_indicator.offset_right = indicator_offset + 10
	
	# Color code based on danger
	var danger_ratio = abs(balance) / fall_threshold
	if danger_ratio < 0.5:
		balance_indicator.modulate = Color.GREEN
	elif danger_ratio < 0.8:
		balance_indicator.modulate = Color.YELLOW
	else:
		balance_indicator.modulate = Color.RED

func game_over():
	game_active = false
	game_over_label.visible = true
	
	if time_survived > high_score:
		high_score = time_survived
		game_over_label.text = "FELL OFF!\n Your time: %d" % time_survived
	else:
		game_over_label.text = "FELL OFF!\nTime: %.1f s\nBest: %.1f s" % [time_survived, high_score]
	
	instructions_label.visible = false
	if (time_survived > 25):
		music_player.stop()
		GameManager.finish_game("Tight Rope", int(time_survived*2), "tight_rope_big")
	else:
		music_player.stop()
		GameManager.finish_game("Tight Rope", int(time_survived*2), "tight_rope_small")

func reset_game():
	balance = 0.0
	time_survived = 0.0
	difficulty_multiplier = 1.0
	game_active = true
	player.rotation = 0
	# Don't reset position - leave player where you placed them in the scene
	game_over_label.visible = false
	instructions_label.visible = true


# Scene structure setup (add these as children in your scene):
# This script expects:
# - Player (Polygon2D or Sprite2D for the character)
# - Rope (Line2D or Sprite2D for the tightrope)
# - UI/BalanceBar (ColorRect)
# - UI/BalanceBar/Indicator (ColorRect)
# - UI/TimerLabel (Label)
# - UI/GameOverLabel (Label)
# - UI/InstructionsLabel (Label)
