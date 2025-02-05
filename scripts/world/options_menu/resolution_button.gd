extends OptionButton

const resolutions : Dictionary = {
	"640x480"   = Vector2i(640 ,480),
	"780x480"   = Vector2i(720 ,480),
	"1280x720"  = Vector2i(1280, 720),
	"1600x900"  = Vector2i(1600, 900),
	"1920x1080" = Vector2i(1920,1080),
	"2560x1440" = Vector2i(2560,1440),
	"3440x1440" = Vector2i(3440,1440),
	"3840x2160" = Vector2i(3840,2160)
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var screen_x_value : int = DisplayServer.screen_get_size().x
	var screen_y_value : int = DisplayServer.screen_get_size().y
	for res in resolutions:
		if resolutions[res].x > screen_x_value or resolutions[res].y > screen_y_value:
			break
		self.add_item(res)
	var config : ConfigFile = ConfigFile.new()
	config.load("user://savedata.cfg")
	selected = config.get_value("settings","resolution",0)
