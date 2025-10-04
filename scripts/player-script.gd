extends CharacterBody2D

var direction : Vector2 = Vector2()
@onready var animated_sprite = $AnimatedSprite2D  # Make sure this matches your node name

func read_input():
	velocity = Vector2()
	
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
		direction = Vector2(0, -1)
		animated_sprite.play("idle_up")
		
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
		direction = Vector2(0, 1)
		animated_sprite.play("idle_down")
		
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
		direction = Vector2(-1, 0)
		animated_sprite.play("idle_left")
		
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
		direction = Vector2(1, 0)
		animated_sprite.play("idle_right")
		
	velocity = velocity.normalized()
	velocity = velocity * 200

func _physics_process(delta: float):
	read_input()
	move_and_slide()

func _ready():
	position = Global.player_spawn_position
