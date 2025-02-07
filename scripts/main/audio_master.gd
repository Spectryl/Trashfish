extends Node2D
@onready var sound_master = $sound_master
@onready var music_master = $music_master

@onready var master_bus_index : int = AudioServer.get_bus_index("Master")
@onready var music_bus_index  : int = AudioServer.get_bus_index("Music")
@onready var sound_bus_index  : int = AudioServer.get_bus_index("Sound")
func _ready() -> void:
	global.audio_master = self

# Has the Audio_master setup audio called from game_master, doing it like this so we avoid a race on the ready
func set_up_audio(password : String) -> void:
	var config = ConfigFile.new()
	var error = config.load_encrypted_pass("user://savedata.cfg", password)
	if error != OK:
		print("error:", error)
		config.set_value("settings", "master_volume", 1.0)
		config.set_value("settings", "music_volume" , 1.0)
		config.set_value("settings", "sound_volume" , 1.0)
		config.save_encrypted_pass("user://savedata.cfg", password)
	
	AudioServer.set_bus_volume_db(master_bus_index, linear_to_db(config.get_value("settings",  "master_volume", 1.0)))
	AudioServer.set_bus_volume_db(music_bus_index,  linear_to_db(config.get_value("settings",  "music_volume",  1.0)))
	AudioServer.set_bus_volume_db(sound_bus_index,  linear_to_db(config.get_value("settings",  "sound_volume",  1.0)))
