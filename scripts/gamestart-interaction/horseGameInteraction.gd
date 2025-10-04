# MinigameInteraction.gd
# Attach this to an Area2D node in your main scene

extends Area2D

@export var minigame_name: String = "Horse Race"  # Change this in inspector
# @export var minigame_scene_path: String = "res://scenes/horsymang/horse_race.tscn"  # Path to your minigame scene

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
	dialog_text.text = "Play minigame:\n" + minigame_name + "?"

var can_interact = true

func _process(delta):
	if player_in_range and can_interact and Input.is_action_just_pressed("ui_accept"):
		print("\n=== E PRESSED (HORSE GAME) ===")
		print("player_in_range: ", player_in_range)
		print("can_interact: ", can_interact)
		print("Scene path: ", "res://scenes/horsymang/horse_race.tscn")
		_show_dialog()

func _show_dialog():
	print("_show_dialog called (HORSE)")
	can_interact = false
	dialog_box.visible = true
	prompt_label.visible = false
	print("Dialog box visible: ", dialog_box.visible)

func _on_no_pressed():
	dialog_box.visible = false
	prompt_label.visible = true
	
	# Small delay before allowing interaction again
	await get_tree().create_timer(0.1).timeout
	can_interact = true
	
	# Release inputs
	Input.action_release("ui_accept")
	get_viewport().gui_release_focus()

func _on_body_entered(body):
	if body is CharacterBody2D:  # Remove the "and body.name == Player" part
		player_in_range = true
		prompt_label.visible = true
		# Keep the unique text line

func _on_body_exited(body):
	if body is CharacterBody2D:  # Same here
		player_in_range = false
		prompt_label.visible = false
		dialog_box.visible = false
		
		# Release focus when leaving area
		if no_button:
			no_button.release_focus()
		if yes_button:
			yes_button.release_focus()
		get_viewport().gui_release_focus()


func _on_yes_pressed():
	# Load and switch to minigame scene
	Global.player_spawn_position = position # Your coordinates
	get_tree().change_scene_to_file("res://scenes/horsymang/horse_race.tscn")
