extends Node
@onready var password : String  = "freedom"
var save_data : ConfigFile
var controls  : ConfigFile

func _ready() -> void:
	save_data = ConfigFile.new()
	var error1 = save_data.load_encrypted_pass("user://savedata.cfg", password)

	controls = ConfigFile.new()
	var error2 = controls.load_encrypted_pass("user://controls.cfg", password)

	if error1 != OK:
		save_data = ConfigFile.new()
		save_data.set_value("settings", "master_volume", 1.0)
		save_data.set_value("settings", "music_volume", 1.0)
		save_data.set_value("settings", "sound_volume", 1.0)
		save_data.set_value("settings", "window", 1)
		save_data.set_value("player", "beach_classic_high_score", 0)
		save_data.set_value("player", "beach_guns_high_score", 0)
		save_data.save_encrypted_pass("user://savedata.cfg", password)
		print("No Save file found!")
		
	if error2 != OK:
		controls = ConfigFile.new()
		controls.save_encrypted_pass("user://controls.cfg", password)
		print("No Controls File found!")

## run this to save time and not mess up saving the savedata
func save_savedata() -> void:
	save_data.save_encrypted_pass("user://savedata.cfg", password)

## run this to save time and not mess up saving controls
func save_controls() -> void:
	controls.save_encrypted_pass("user://controls.cfg", password)
