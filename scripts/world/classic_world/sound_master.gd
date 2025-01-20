extends Node
@onready var bloop : AudioStreamPlayer       = $bloop
@onready var explosion1 : AudioStreamPlayer  = $explosion1
@onready var chomp      : AudioStreamPlayer  = $chomp
@onready var rifle_shot  : AudioStreamPlayer = $rifle_shot
@onready var fuse  : AudioStreamPlayer       = $fuse



var sound_dictionary = {
}

func _ready() -> void:
	sound_dictionary["bloop"]      = bloop
	sound_dictionary["explosion1"] = explosion1
	sound_dictionary["chomp"]      = chomp
	sound_dictionary["rifle_shot"] = rifle_shot
	sound_dictionary["fuse"]       = fuse


func play(sfx_name : String):
	sound_dictionary[sfx_name].play()

func stop(sfx_name : String):
	sound_dictionary[sfx_name].stop()
