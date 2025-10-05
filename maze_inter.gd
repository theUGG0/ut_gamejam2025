# MinigameInteraction.gd
# Attach this to an Area2D node in your main scene

extends Area2D

@export var minigame_name: String = ""  # Change this in inspector
@export var minigame_scene_path: String = ""  # Path to your minigame scene

func _ready():
	# Connect signals
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	GameManager.player_spawn_pos = body.position
	GameManager.display_game_start_dialogue(minigame_name, minigame_scene_path)

func _on_body_exited(body):
	GameManager.hide_game_start_dialogue()
