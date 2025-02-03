extends Control
@onready var menu : Control = get_parent()

@onready var master_volume_slider : HSlider = $TabContainer/Sound/master_volume_container/master_volume_slider
@onready var music_volume_slider  : HSlider = $TabContainer/Sound/master_volume_container/master_volume_slider
@onready var sound_volume_slider  : HSlider = $TabContainer/Sound/sound_volume_container/sound_volume_slider

var config : ConfigFile
var master_volume : float
var music_volume  : float
var sound_volume  : float

func _ready() -> void:
	config = ConfigFile.new()
	var error = config.load("user://savedata.cfg")
	if error != OK:
		print("error:", error)
		master_volume = 1.0
		music_volume  = 1.0
		sound_volume  = 1.0
	else:
		master_volume = config.get_value("settings",  "master_volume", 1.0)
		music_volume  = config.get_value("settings",  "music_volume" , 1.0)
		sound_volume  = config.get_value("settings",  "sound_volume" , 1.0)
	master_volume_slider.value = master_volume
	music_volume_slider.value  = music_volume
	sound_volume_slider.value  = sound_volume

func _on_texture_button_pressed() -> void:
	config.set_value("settings", "master_volume", db_to_linear(AudioServer.get_bus_volume_db(global.audio_master.master_bus_index)))
	config.set_value("settings", "music_volume" , db_to_linear(AudioServer.get_bus_volume_db(global.audio_master.music_bus_index)))
	config.set_value("settings", "sound_volume" , db_to_linear(AudioServer.get_bus_volume_db(global.audio_master.sound_bus_index)))
	config.save("user://savedata.cfg")
	menu.switch_menu(0)
