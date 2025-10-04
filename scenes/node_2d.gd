extends CharacterBody2D

@export var speed = 400

var screen_size
const G = 200.0
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	screen_size = get_viewport_rect().size # Replace with function body.
	print(position.y)
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _physics_process(delta: float) -> void:
	var velocity = Vector2.ZERO
	move_and_collide(Vector2(0,1))
	if Input.is_action_pressed('ui_right'):
		velocity.x +=1

	elif Input.is_action_pressed('ui_left'):
		velocity.x -=1

	elif Input.is_action_just_pressed('ui_up'):
		velocity.y -= 20
		print(position.y)
		if position.y <= -20:
			velocity.y = 0

		'''elif position.y <= -9:
			velocity.y = -20''' #double jump?

	if velocity.length() > 0:
		velocity = velocity * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0

	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0

	position += velocity * delta
	
