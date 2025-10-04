# MinigameInteraction.gd
# Attach this to an Area2D node in your main scene

extends Area2D

@export var minigame_name: String = "Puzzle Game"  # Change this in inspector
@export var minigame_scene_path: String = "res://scenes/dino_mang/dino_taust.tscn"  # Path to your minigame scene

var player_in_range = false
var prompt_visible = false

# Reference to UI elements (we'll create these)
@onready var prompt_label = $PromptLabel  # "Press E"
@onready var dialog_box = $DialogBox  # The popup box
@onready var dialog_text = $DialogBox/DialogText
@onready var yes_button = $DialogBox/YesButton
@onready var no_button = $DialogBox/NoButton

func _ready():
	# Connect signals
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	yes_button.pressed.connect(_on_yes_pressed)
	no_button.pressed.connect(_on_no_pressed)
	
	# Hide everything at start
	prompt_label.visible = false
	dialog_box.visible = false
	
	# Set dialog text
	dialog_text.text = "Do you want to play minigame:\n" + minigame_name + "?"

func _process(delta):
	# Check for E key press when player is in range
	if player_in_range and Input.is_action_just_pressed("ui_accept"):  # We'll map E to this
		_show_dialog()

func _on_body_entered(body):
	if body is CharacterBody2D:  # Your player
		player_in_range = true
		prompt_label.visible = true

func _on_body_exited(body):
	if body is CharacterBody2D:
		player_in_range = false
		prompt_label.visible = false
		dialog_box.visible = false

func _show_dialog():
	dialog_box.visible = true
	prompt_label.visible = false
	# Optional: pause game or disable player movement here

func _on_yes_pressed():
	# Load and switch to minigame scene
	get_tree().change_scene_to_file(minigame_scene_path)

func _on_no_pressed():
	# Close dialog
	dialog_box.visible = false
	prompt_label.visible = true  # Show "Press E" again
