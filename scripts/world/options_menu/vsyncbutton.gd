extends CheckButton


func _ready() -> void:
	var config : ConfigFile = ConfigFile.new()
	config.load_encrypted_pass("user://savedata.cfg", global.game_master.password)
	button_pressed = config.get_value("settings","vsync",true)
