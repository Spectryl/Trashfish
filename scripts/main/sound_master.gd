extends Node
@onready var bloop : AudioStreamPlayer       = $bloop
@onready var chomp      : AudioStreamPlayer  = $chomp
@onready var drop_splash : AudioStreamPlayer = $drop_splash
@onready var explosion1 : AudioStreamPlayer  = $explosion1
@onready var rifle_shot  : AudioStreamPlayer = $rifle_shot
@onready var fuse  : AudioStreamPlayer       = $fuse
@onready var wave_splash : AudioStreamPlayer = $wave_splash



var sound_dictionary = {
}

func _ready() -> void:
	# Have to declare the dictionary like this because onready priority moment
	sound_dictionary["bloop"]      = bloop
	sound_dictionary["explosion1"] = explosion1
	sound_dictionary["chomp"]      = chomp
	sound_dictionary["rifle_shot"] = rifle_shot
	sound_dictionary["fuse"]       = fuse
	sound_dictionary["wave_splash"]= wave_splash
	sound_dictionary["drop_splash"]= drop_splash
	global.sound_master = self

func play(sfx_name : String):
	sound_dictionary[sfx_name].play_audio()

func stop(sfx_name : String):
	sound_dictionary[sfx_name].stop()
