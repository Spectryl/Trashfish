extends Node
@onready var bloop : AudioStreamPlayer       = $bloop
@onready var button_hover : AudioStreamPlayer= $button_hover
@onready var chomp1     : AudioStreamPlayer  = $chomp1
@onready var chomp2     : AudioStreamPlayer  = $chomp2
@onready var chomp3     : AudioStreamPlayer  = $chomp3
@onready var drop_splash : AudioStreamPlayer = $drop_splash
@onready var explosion1 : AudioStreamPlayer  = $explosion1
@onready var fuse  : AudioStreamPlayer       = $fuse
@onready var heal        : AudioStreamPlayer = $heal
@onready var rifle_shot1  : AudioStreamPlayer= $rifle_shot1
@onready var rifle_shot2  : AudioStreamPlayer= $rifle_shot2
@onready var rifle_shot3  : AudioStreamPlayer= $rifle_shot3
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
	sound_dictionary["chomp1"]       = chomp1
	sound_dictionary["chomp2"]       = chomp2
	sound_dictionary["chomp3"]       = chomp3
	sound_dictionary["drop_splash"]  = drop_splash
	sound_dictionary["explosion1"]   = explosion1
	sound_dictionary["fuse"]         = fuse
	sound_dictionary["heal"]         = heal
	sound_dictionary["rifle_shot1"]  = rifle_shot1
	sound_dictionary["rifle_shot2"]  = rifle_shot2
	sound_dictionary["rifle_shot3"]  = rifle_shot3
	sound_dictionary["small_chomp"]  = small_chomp
	sound_dictionary["ui_music_test"]= ui_music_test
	sound_dictionary["ui_sfx_test"]  = ui_sfx_test
	sound_dictionary["wave_splash"]  = wave_splash
	global.sound_master = self

#Plays a sound effect
func play(sfx_name : String):
	sound_dictionary[sfx_name].play_audio()
# stops a sound effect (this shouldn't be used
func stop(sfx_name : String):
	sound_dictionary[sfx_name].stop()


## Handles playing the different chomp sound effects to avoid noise fatigue, use this for the player attacking
func play_chomp():
	var chomp_to_play : String = ""
	match randi_range(0,2):
		0:
			chomp_to_play = "chomp1"
		1:
			chomp_to_play = "chomp2"
		_:
			chomp_to_play = "chomp3"
	self.play(chomp_to_play)

func play_gunshot():
	var gunshot_to_play : String = ""
	match randi_range(0,2):
		0:
			gunshot_to_play = "rifle_shot1"
		1:
			gunshot_to_play = "rifle_shot2"
		_:
			gunshot_to_play = "rifle_shot3"
	self.play(gunshot_to_play)
