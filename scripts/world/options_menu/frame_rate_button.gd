extends OptionButton
func _ready() -> void:
	theme = Theme.new()
	theme.default_font = FontFile.new()
	theme.default_font_size = 50
	theme.default_font.font_data = load("res://font/VT323-Regular.ttf")

	var fps : int = 15
	for i in range(10):
		add_item(str(fps))
		fps += 15
		if fps == 135:
			fps = 144 #okay if you are past this point, then you probaby got goofy ah number 144 hertz
		if fps > DisplayServer.screen_get_refresh_rate():
			break
	selected = save_master.save_data.get_value("settings","framerate",0) / 15 - 1 #convert it back into indexes
	
