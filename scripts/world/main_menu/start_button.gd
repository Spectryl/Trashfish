extends Node2D

func attacked():
	get_tree().change_scene_to_file("res://scenes/world/classic_world/world.tscn")
	load_save_data()
	
	
# Will create a save file if the player does not have one, otherwise it does nothing really.
func load_save_data():
	var config = ConfigFile.new()
	var error = config.load("user://savedata.cfg")
	if error != OK:
		config = ConfigFile.new()
		config.set_value("player", "classic_high_score", 0)
		config.save("user://savedata.cfg")
		print("No Save file found!")
	else:
		print("Save file found")
