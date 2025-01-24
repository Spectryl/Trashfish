extends Node2D
@onready var world : Node2D
@onready var player : CharacterBody2D
@onready var audio_master : Node2D

const main_menu_scene = preload("res://scenes/world/main_menu/main_menu.tscn")
const player_scene    = preload("res://scenes/player/player.tscn")
const audio_scene     = preload("res://scenes/main/audio_master.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
