extends CharacterBody2D

var screen_width
var half_character_width
const SPEED = 400
func _ready():
	screen_width = get_viewport_rect().size.x
	position.y = 1000
	#half_character_width = $Sprite2D/LiikuvObjekt.texture.get_width()/2.0
	
func _physics_process(delta: float) -> void:
	velocity.x = -SPEED
	move_and_slide()
	print(position)
	if position.x < -10:
		position.x = screen_width + 50
	
		


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method('die'):
		
		body.die() # Replace with function body.
