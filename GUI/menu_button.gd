extends TextureButton




func _on_MenuButton_mouse_entered():
	$Label.material.set_shader_param("strength", 1)


func _on_MenuButton_mouse_exited():
	$Label.material.set_shader_param("strength", 0)
