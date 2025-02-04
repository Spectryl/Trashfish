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
