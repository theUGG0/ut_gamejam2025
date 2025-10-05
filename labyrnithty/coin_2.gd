extends Area2D

signal collected

var positions = [Vector2(49.0,185.0),Vector2(340.0,321.0)]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position = positions.pick_random()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	$Sprite2D.visible = false
	emit_signal("collected")
	queue_free()
