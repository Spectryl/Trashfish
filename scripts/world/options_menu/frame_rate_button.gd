extends OptionButton
func _ready() -> void:
	var fps : int = 15
	for i in range(10):
		add_item(str(fps))
		fps += 15
		if fps == 135:
			fps = 144 #okay if you are past this point, then you probaby got goofy ah number 144 hertz
		if fps > DisplayServer.screen_get_refresh_rate():
			break
	var config : ConfigFile = ConfigFile.new()
	config.load("user://savedata.cfg")
	selected = config.get_value("settings","framerate",0) / 15 - 1 #convert it back into indexes
	
