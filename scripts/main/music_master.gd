extends Node
@onready var lisa : AudioStreamPlayer               = $lisa
@onready var midnight_sands : AudioStreamPlayer     = $midnight_sands
@onready var nighttime_solitude : AudioStreamPlayer = $nighttime_solitude
var current_song_playing : String = "none"
var music_dictionary : Dictionary = {
}

func _ready() -> void:
	# Have to declare the dictionary like this because onready priority moment
	music_dictionary["lisa"]               = lisa
	music_dictionary["midnight_sands"]     = midnight_sands
	music_dictionary["nighttime_solitude"] = nighttime_solitude
	global.music_master = self
	play("midnight_sands")

	lisa.connect("finished", song_has_ended)
	midnight_sands.connect("finished", song_has_ended)
	nighttime_solitude.connect("finished", song_has_ended)


# Ends the current song and plays the new song
func change_song(new_song_file_name : String) -> void:
	if new_song_file_name == current_song_playing:
		return
	stop(current_song_playing)
	play(new_song_file_name)

# Plays a new song and changes the current song variable to the new one
func play(song_file_name : String) -> void:
	music_dictionary[song_file_name].play()
	current_song_playing = song_file_name

# Ends the channel of the song specified
func stop(song_file_name : String) -> void:
	if current_song_playing == "none":
		return;
	music_dictionary[song_file_name].stop()

# if we need to terminate all music, then do this
func end_all_music() -> void:
	stop(current_song_playing)
	current_song_playing = "none"

# should reset the song, have all song "finished signals" attach to this
func song_has_ended() -> void:
	play(current_song_playing)
