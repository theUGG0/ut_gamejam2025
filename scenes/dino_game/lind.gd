extends CharacterBody2D

const g = 1000
const max_vel = 600
const flap_speed = -500
var flying = false
var falling = false
const start_p = Vector2(100,400)

func _ready():
	reset()
	
func reset():
	falling = false
	flying = false
	position = start_p 
	set_rotation(0)
func _physics_process(delta: float) -> void:
	if flying or falling:
		velocity.y += g*delta
		if velocity.y > max_vel:
			velocity.y = max_vel
		if flying:
			set_rotation(deg_to_rad(velocity.y *0.05))
			$AnimatedSprite2D.play()
		elif falling:
			set_rotation(PI/2)
			$AnimatedSprite2D.stop()
		move_and_collide(velocity*delta)
	else:
		$AnimatedSprite2D.stop()

func flap():
	velocity.y = flap_speed
