extends Node2D
@onready var world : Node2D
@onready var player : CharacterBody2D
@onready var audio_master  : Node2D = $audio_master
@onready var player_master : Node2D = $player_master
@onready var world_master  : Node2D = $world_master
@onready var password : String  = "freedom"
const resolutions : Dictionary = {
	"640x480"   = Vector2i(640 ,480),
	"780x480"   = Vector2i(720 ,480),
	"1280x720"  = Vector2i(1280, 720),
	"1920x1080" = Vector2i(1920,1080),
	"2560x1440" = Vector2i(2560,1440),
	"3440x1440" = Vector2i(3440,1440),
	"3840x2160" = Vector2i(3840,2160)
}
func _ready() -> void:
	if OS.has_environment("USERNAME") and OS.get_environment("USERNAME").to_lower().count("thang", 0,0) > 0:
		OS.crash("In order to remain ICE Compliant, this user is BANNED from all SonuTheNecro LTD Media")
		
	
	global.game_master = self
	check_save()
	var config : ConfigFile = ConfigFile.new()
	config.load_encrypted_pass("user://savedata.cfg", password)
	audio_master.set_up_audio(password)
	change_display(config.get_value("settings", "window", 1))
	change_resolution(config.get_value("settings", "resolution", 2))
# Checks if a player save is created
func check_save() -> void:
	# Will create a save file if the player does not have one, otherwise it does nothing really.
	var config : ConfigFile = ConfigFile.new()
	var error : Error = config.load_encrypted_pass("user://savedata.cfg", password)
	if error != OK:
		config = ConfigFile.new()
		config.set_value("settings", "master_volume", 1.0)
		config.set_value("settings", "music_volume", 1.0)
		config.set_value("settings", "sound_volume", 1.0)
		config.set_value("settings", "window", 1)
		config.set_value("player", "classic_high_score", 0)
		config.save_encrypted_pass("user://savedata.cfg", password)
		print("No Save file found!")
	else:
		print("Save file found")

func change_display(index : int) -> void:
	match index:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		2:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)

func change_resolution(index : int) -> void:
	DisplayServer.window_set_size(resolutions.values()[index])
	var centre_screen = DisplayServer.screen_get_position() + DisplayServer.screen_get_size()/2
	var window_size = get_window().get_size_with_decorations()
	get_window().set_position(centre_screen - window_size/2)
