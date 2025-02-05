extends CheckButton


func _ready() -> void:
	var config : ConfigFile = ConfigFile.new()
	config.load("user://savedata.cfg")
	button_pressed = config.get_value("settings","vsync",true)
