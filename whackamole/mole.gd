extends Node2D

var positions = [Vector2(800,360), Vector2(1180,360), Vector2(995,465), Vector2(740,538), Vector2(1232,542),Vector2(983, 679), Vector2(718, 774), Vector2(1228,785)]
var hit = false
var clicked = false
var used = 0
var time = 0.2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if hit:
		_move_mole()
		hit = false

func _input(event):	
	if event is InputEventMouseButton and event.pressed:
		clicked = not clicked
		if not clicked:
			used = 0

func _move_mole():
	$Sprite2D2.texture = load("res://pildid/mole_peidus_transparent.png")
	await get_tree().create_timer(time).timeout
	$Sprite2D2.visible = false
	await get_tree().create_timer(time).timeout
	global_position = positions.pick_random()
	$Sprite2D2.visible = true
	await get_tree().create_timer(time).timeout
	$Sprite2D2.texture = load("res://pildid/mole_väljas_transparent.png")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if clicked and used == 0:
		hit = true
		used = 1

	#print("Mole whacked!",body.name)
