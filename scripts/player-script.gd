extends CharacterBody2D

var direction : Vector2 = Vector2()
@onready var animated_sprite = $AnimatedSprite2D

func read_input():
	velocity = Vector2()
	var is_moving = false
	
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
		direction = Vector2(0, -1)
		is_moving = true
		
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
		direction = Vector2(0, 1)
		is_moving = true
		
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
		direction = Vector2(-1, 0)
		is_moving = true
		
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
		direction = Vector2(1, 0)
		is_moving = true
	
	# Play animations based on movement and direction
	if is_moving:
		velocity = velocity.normalized() * 200
		
		# Play walking animations while moving
		if abs(direction.x) > abs(direction.y):
			# Horizontal movement
			if direction.x > 0:
				animated_sprite.play("walk_right")
			else:
				animated_sprite.play("walk_left")
		else:
			# Vertical movement
			if direction.y > 0:
				animated_sprite.play("walk_down")
			else:
				animated_sprite.play("walk_up")
	else:
		# Standing still - use last direction for idle
		if abs(direction.x) > abs(direction.y):
			if direction.x > 0:
				animated_sprite.play("idle_right")
			else:
				animated_sprite.play("idle_left")
		else:
			if direction.y > 0:
				animated_sprite.play("idle_down")
			else:
				animated_sprite.play("idle_up")

func _physics_process(delta: float):
	read_input()
	move_and_slide()

func _ready():
	position = GameManager.player_spawn_pos

func _exit_tree():
	GameManager.player_spawn_pos = position
