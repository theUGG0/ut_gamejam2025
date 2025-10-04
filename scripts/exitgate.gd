extends Area2D

func _ready():
	body_entered.connect(_on_body_entered)
	print("ExitGate ready!")

func _on_body_entered(body):
	print("Something entered the gate: ", body.name, " Type: ", body.get_class())
	if body is CharacterBody2D:  # Better check than name
		print("Player detected - exiting!")
		get_tree().quit()
