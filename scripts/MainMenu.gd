extends Control

# References to buttons
@onready var play_button = $PlayButton
@onready var quit_button = $QuitButton

func _ready():
	# Connect button signals
	play_button.pressed.connect(_on_play_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

func _on_play_pressed():
	# Change to your game scene
	get_tree().change_scene_to_file("res://scenes/main.tscn")
	# Or if you have a specific scene:
	# get_tree().change_scene_to_file("res://scenes/circus_game.tscn")


func _on_quit_pressed():
	# Quit the game
	get_tree().quit()


# SCENE STRUCTURE (SIMPLIFIED - NO CONTAINER):
# Create this node hierarchy:
#
# MainMenu (Control) - attach this script
# ├── Background (TextureRect or ColorRect) - optional background
# ├── PlayButton (Button or TextureButton)
# ├── SettingsButton (Button or TextureButton)
# └── QuitButton (Button or TextureButton)
#
# SETUP INSTRUCTIONS:
# 1. Create a new scene with Control node as root
# 2. Add three Button/TextureButton nodes directly as children
# 3. Position them MANUALLY wherever you want in the scene editor
# 4. The script will NOT move them - they stay where you place them!
