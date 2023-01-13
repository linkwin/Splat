extends Resource
class_name SaveGame

export var levels_completed = []

export var last_level = "Level1"

func wipe_save():
	levels_completed = []
	last_level = "Level1"
	ResourceSaver.save("res://Resource/default_save.tres", self)

func unlock_all_levels():
	var levels = FuncLib.get_files_in_dir("res://Core/Levels/LevelScenes/")
	for level in levels:
		levels_completed.append(level.split(".")[0])
	ResourceSaver.save("res://Resource/default_save.tres", self)

func level_complete(level, next_level):
	last_level = next_level
	levels_completed.append(level)
	ResourceSaver.save("res://Resource/default_save.tres", self)	
