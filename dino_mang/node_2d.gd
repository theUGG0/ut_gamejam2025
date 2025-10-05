extends AnimatedSprite2D

@export var speed = 400
var screen_size 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size # Replace with function body.

var direction : Vector2 = Vector2()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity = Vector2.ZERO
	if Input.is_action_pressed('ui_right'):
		velocity.x +=1
	if Input.is_action_pressed('ui_left'):
		velocity.x -=1
	if Input.is_action_pressed('ui_up'):
		velocity.y -= 1
	if Input.is_action_pressed('ui_down'):
		velocity.y += 1

		
	if velocity.length() > 0:
		velocity = velocity.normalized() *speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
	# See the note below about the following boolean assignment.
		$AnimatedSprite2D.flip_h = velocity.x < 0
	if velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0
		
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
