extends Node2D
var player : CharacterBody2D

const player_scene = preload("res://scenes/player/player.tscn")
func _ready() -> void:
	player = player_scene.instantiate()
	self.add_child(player)
	global.player = player 
	change_player_global_position(Vector2(300,380))
	change_player_scale(3.0)
	print(player.global_position)

# changes the player scale based on what world we are changing to
func change_player_scale(new_value : float):
	player.set_global_scale(Vector2(new_value,new_value))
#func change_player_scale(new_value : Vector2):
	#player.set_global_scale(new_value)

# Changes the player's speed variable (this is permanent)
func change_player_speed(new_value : float):
	player.speed = new_value
# Changes the player's global position (use this when we change worlds)
func change_player_global_position(new_position : Vector2):
	player.global_position = new_position
