extends Node2D

export(Resource) var save = preload("res://Resource/default_save.tres")

func _on_NewGame_pressed():
	save.wipe_save()
	get_tree().change_scene("res://Core/Levels/LevelScenes/Level1.tscn")

func _on_Continue_pressed():
	get_tree().change_scene("res://Core/Levels/LevelScenes/" + save.last_level + ".tscn")

func _on_LevelSelect_pressed():
	$UI/LevelSelect.visible = not $UI/LevelSelect.visible

func _on_Quit_pressed():
	get_tree().quit()

func _on_UnlockAll_pressed():
	save.unlock_all_levels()
