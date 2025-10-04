extends CharacterBody2D

var clicked = false

func _input(event):	
	if event is InputEventMouseButton and event.pressed:
		clicked = not clicked

		if clicked:
			global_rotation_degrees = 0.0
		else:
			global_rotation_degrees = 48.0

	elif event is InputEventMouseMotion:
		global_position= event.position


func _ready() -> void:
	global_rotation_degrees = 48.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
