extends Node
@onready var bloop : AudioStreamPlayer       = $bloop
@onready var button_hover : AudioStreamPlayer= $button_hover
@onready var chomp      : AudioStreamPlayer  = $chomp
@onready var drop_splash : AudioStreamPlayer = $drop_splash
@onready var explosion1 : AudioStreamPlayer  = $explosion1
@onready var rifle_shot  : AudioStreamPlayer = $rifle_shot
@onready var fuse  : AudioStreamPlayer       = $fuse
@onready var small_chomp : AudioStreamPlayer = $small_chomp
@onready var wave_splash : AudioStreamPlayer = $wave_splash
@onready var ui_sfx_test : AudioStreamPlayer = $ui_sfx_test
@onready var ui_music_test:AudioStreamPlayer = $ui_music_test



var sound_dictionary : Dictionary = {
}

func _ready() -> void:
	# Have to declare the dictionary like this because onready priority moment
	sound_dictionary["bloop"]        = bloop
	sound_dictionary["button_hover"] = button_hover
	sound_dictionary["explosion1"]   = explosion1
	sound_dictionary["chomp"]        = chomp
	sound_dictionary["rifle_shot"]   = rifle_shot
	sound_dictionary["fuse"]         = fuse
	sound_dictionary["wave_splash"]  = wave_splash
	sound_dictionary["drop_splash"]  = drop_splash
	sound_dictionary["ui_music_test"]= ui_music_test
	sound_dictionary["ui_sfx_test"]  = ui_sfx_test
	sound_dictionary["small_chomp"]  = small_chomp
	global.sound_master = self

#Plays a sound effect
func play(sfx_name : String):
	sound_dictionary[sfx_name].play_audio()
# stops a sound effect (this shouldn't be used
func stop(sfx_name : String):
	sound_dictionary[sfx_name].stop()
