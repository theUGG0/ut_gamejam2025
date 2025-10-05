extends CharacterBody2D

@export var speed := 200


func _ready() -> void:
	position = Vector2(532,621)



func _process(delta: float) -> void:

	var direction = Vector2.ZERO

	if Input.is_action_pressed("left"):
		direction.x -= 1
		$Sprite2D.rotation_degrees = -90
	elif Input.is_action_pressed("right"):
		direction.x += 1
		$Sprite2D.rotation_degrees = 90
	elif Input.is_action_pressed("up"):
		direction.y -= 1
		$Sprite2D.rotation_degrees = 0
	elif Input.is_action_pressed("down"):
		direction.y += 1
		$Sprite2D.rotation_degrees = 180

	velocity = direction * speed 
	move_and_slide()
