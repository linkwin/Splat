extends Area2D

func _on_Area2D_body_entered(body):
	if "player" in body.name:
		print("yup")
		body.gravity_dir = Vector2.DOWN
		body.gravity_changed = true
