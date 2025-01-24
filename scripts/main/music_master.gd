extends Node
@onready var lisa : AudioStreamPlayer            = $lisa
@onready var midnight_sands : AudioStreamPlayer  = $midnight_sands



var music_dictionary = {
}

func _ready() -> void:
	music_dictionary["lisa"]           = lisa
	music_dictionary["midnight_sands"] = midnight_sands


func play(song_file_name : String):
	music_dictionary[song_file_name].play()

func stop(song_file_name : String):
	music_dictionary[song_file_name].stop()
