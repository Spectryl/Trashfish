extends Control
@onready var menu : Control = get_parent()

func _on_start_button_pressed() -> void:
	global.world_master.change_world(2)
	load_save_data()

func _on_options_button_pressed() -> void:
	menu.switch_menu(1)

func _on_controls_button_pressed() -> void:
	global.world_master.change_world(1)

func _on_quit_button_pressed() -> void:
	get_tree().quit()

# Will create a save file if the player does not have one, otherwise it does nothing really.
func load_save_data():
	var config : ConfigFile = ConfigFile.new()
	var error : Error = config.load("user://savedata.cfg")
	if error != OK:
		config = ConfigFile.new()
		config.set_value("player", "classic_high_score", 0)
		config.save("user://savedata.cfg")
		print("No Save file found!")
	else:
		print("Save file found")
