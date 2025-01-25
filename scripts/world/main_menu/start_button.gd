extends Node2D

func attacked():
	global.world_master.change_world(2)
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
