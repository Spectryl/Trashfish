extends OptionButton

const frames_per_second : Array[int] = [
	30,
	60,
	75,
	90,
	120,
	144,
	240,
	360,
	480,
	640, #Gamer fps right here
]

func _ready() -> void:
	theme = Theme.new()
	theme.default_font = FontFile.new()
	theme.default_font_size = 50
	theme.default_font.font_data = load("res://font/VT323-Regular.ttf")

	for fps in frames_per_second:
		if fps > DisplayServer.screen_get_refresh_rate():
			break
		self.add_item(str(fps))
	selected = save_master.save_data.get_value("settings","framerate",0)
	
