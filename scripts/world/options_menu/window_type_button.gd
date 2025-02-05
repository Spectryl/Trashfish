extends OptionButton

const windows_types : Array[String] = [
	"FULLSCREEN",
	"WINDOWED",
	"BORDERLESS WINDOWED"
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for window in windows_types:
		self.add_item(window)
	var config : ConfigFile = ConfigFile.new()
	config.load("user://savedata.cfg")
	selected = config.get_value("settings","window",0)
