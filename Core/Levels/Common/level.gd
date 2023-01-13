extends Node2D

signal level_completed

onready var level_start_time = OS.get_ticks_msec()
var level_end_time


func _on_FinishArea_body_entered(body):
	if "player" in body.name:
		level_end_time = OS.get_ticks_msec()
		body.gravity_dir = Vector2.ZERO
		body.set_process(false)
		var completion_time = (level_end_time - level_start_time) / 1000
		var minutes = str(completion_time / 60)
		var seconds = str(completion_time % 60)
		if completion_time / 60 < 10:
			minutes = "0" + minutes
		if completion_time % 60 < 10:
			seconds = "0" + seconds
		var completion_text = minutes + ":" + seconds
		$UI/LevelCompleteUI/Panel/VBoxContainer/CompletionTime.text = completion_text
		$UI/LevelCompleteUI.show()

func _on_QuitButton_pressed():
	pass # Replace with function body.

func _on_ReplayButton_pressed():
	get_tree().change_scene("res://Core/Levels/LevelScenes/" + name + ".tscn")

func _on_NextLevelButton_pressed():
	var regex = RegEx.new()
	regex.compile("\\d+")
	var level_num = regex.search(name)
	print(level_num.get_string())
	get_tree().change_scene("res://Core/Levels/LevelScenes/Level" + str((int(level_num.get_string()) + 1)) + ".tscn")
	emit_signal("level_completed")
