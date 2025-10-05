extends CharacterBody2D

var screen_width
var half_character_width
const SPEED = 600.0

func _ready():
	screen_width = get_viewport_rect().size.x

	half_character_width = 30
	
func _physics_process(delta: float) -> void:
	
	velocity.x = -SPEED
	move_and_slide()
	if position.x <= -half_character_width:
		position.x = 900
	
