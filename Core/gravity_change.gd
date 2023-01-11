extends Area2D

export var change_dir = Vector2.DOWN

func _on_Area2D_body_entered(body):
	if "player" in body.name:
		print("yup")
		body.gravity_dir = change_dir
		body.gravity_changed = true
