extends Node2D  # or Control, or whatever your root node is

@export var music_file: AudioStream  # Drag your music file here in Inspector

@onready var music_player = AudioStreamPlayer.new()

func _ready():
	# Create and setup music player
	add_child(music_player)
	music_player.stream = music_file
	music_player.play()

func _exit_tree():
	# Stop music when leaving scene
	music_player.stop()
