extends Node


func _on_area_2d_body_entered(body: CharacterBody2D) -> void:
	if body.has_method'die'):
		body.die()
