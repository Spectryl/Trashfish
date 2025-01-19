extends Node2D
@onready var player : CharacterBody2D          = $player
@onready var sound_master : Node               = $sound_master


func _ready() -> void:
	global.player = player
	global.world  = self
	player.world = self
