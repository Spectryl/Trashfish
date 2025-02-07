extends Node2D
@onready var sound_master = $sound_master
@onready var music_master = $music_master

@onready var master_bus_index : int = AudioServer.get_bus_index("Master")
@onready var music_bus_index  : int = AudioServer.get_bus_index("Music")
@onready var sound_bus_index  : int = AudioServer.get_bus_index("Sound")
@onready var game_master   : Node2D = get_parent()
func _ready() -> void:
	global.audio_master = self
	await get_tree().create_timer(1).timeout
	var config = ConfigFile.new()
	var error = config.load_encrypted_pass("user://savedata.cfg", game_master.password)
	if error != OK:
		print("error:", error)
		config.set_value("settings", "master_volume", 1.0)
		config.set_value("settings", "music_volume" , 1.0)
		config.set_value("settings", "sound_volume" , 1.0)
		config.save("user://savedata.cfg")
	
	AudioServer.set_bus_volume_db(master_bus_index, linear_to_db(config.get_value("settings",  "master_volume", 1.0)))
	AudioServer.set_bus_volume_db(music_bus_index,  linear_to_db(config.get_value("settings",  "music_volume",  1.0)))
	AudioServer.set_bus_volume_db(sound_bus_index,  linear_to_db(config.get_value("settings",  "sound_volume",  1.0)))
