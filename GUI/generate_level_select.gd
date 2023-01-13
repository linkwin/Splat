extends GridContainer

var level_button_scene = preload("res://GUI/LevelButton.tscn")

func _ready():
	var levels = FuncLib.get_files_in_dir("res://Core/Levels/LevelScenes/")
	var i = 1
	for level in levels:
		var level_button = level_button_scene.instance()
		level_button.get_node("LevelNumber").text = str(i)
		add_child(level_button)
		i += 1
