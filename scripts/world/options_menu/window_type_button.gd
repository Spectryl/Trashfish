extends OptionButton

const windows_types : Array[String] = [
	"FULLSCREEN",
	"WINDOWED",
	"BORDERLESS WINDOWED"
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	theme = Theme.new()
	theme.default_font = FontFile.new()
	theme.default_font_size = 50
	theme.default_font.font_data = load("res://font/VT323-Regular.ttf")

	for window in windows_types:
		self.add_item(window)
	selected = save_master.save_data.get_value("settings","window",0)
