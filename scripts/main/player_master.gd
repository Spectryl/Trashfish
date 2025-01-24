extends Node2D
static var player : CharacterBody2D


func _ready() -> void:
	player = $player # have to do it like this since static vars don't work with @onready...
	global.player = player 

# changes the player scale based on what world we are changing to
static func change_player_scale(new_value : float):
	player.set_global_scale(Vector2(new_value,new_value))
