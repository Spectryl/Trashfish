extends Node2D
@onready var world : Node2D
@onready var player : CharacterBody2D
@onready var audio_master  : Node2D = $audio_master
@onready var player_master : Node2D = $player_master
@onready var world_master  : Node2D = $world_master


func _ready() -> void:
	global.game_master = self
	check_save()
	var config : ConfigFile = ConfigFile.new()
	config.load("user://savedata.cfg")
	change_display(config.get_value("settings", "window", 1))

# Checks if a player save is created
func check_save() -> void:
	# Will create a save file if the player does not have one, otherwise it does nothing really.
	var config : ConfigFile = ConfigFile.new()
	var error : Error = config.load("user://savedata.cfg")
	if error != OK:
		config = ConfigFile.new()
		config.set_value("settings", "master_volume", 1.0)
		config.set_value("settings", "music_volume", 1.0)
		config.set_value("settings", "sound_volume", 1.0)
		config.set_value("settings", "window", 1)
		config.set_value("player", "classic_high_score", 0)
		config.save("user://savedata.cfg")
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
