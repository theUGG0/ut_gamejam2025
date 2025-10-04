extends Control

func _ready():
	update_score_display()

func update_score_display():
	$MarginContainer/HBoxContainer/ScoreLabel.text = str(GameManager.get_total_score())
