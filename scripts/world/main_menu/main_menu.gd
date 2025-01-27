extends Node2D
@onready var player : CharacterBody2D          = global.player
@onready var sound_master : Node               = global.sound_master
@onready var menu : Control                    = $menu
var world_id = 0 #would be better if composition was used here but its one variable
