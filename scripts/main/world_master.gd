extends Node2D
@onready var world : Node2D

const main_menu_scene    = preload("res://scenes/world/main_menu/main_menu.tscn")
const control_menu_scene = preload("res://scenes/world/controls_menu/controls_screen.tscn")
const beach_world_scene  = preload("res://scenes/world/classic_world/world.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global.world = world
	global.world_master = self
	world = main_menu_scene.instantiate()
	self.add_child(world)


# Changes what world/level we are on
func change_world(world_id : int):
	world.queue_free()
	match world_id:
		0:
			world = main_menu_scene.instantiate()
			global.player_master.change_player_scale(3.0)
			global.music_master.change_song("midnight_sands")
		1:
			world = control_menu_scene.instantiate()
			global.player_master.change_player_scale(3.0)
		2:
			world = beach_world_scene.instantiate()
			global.player_master.change_player_scale(2.0)
			global.music_master.change_song("lisa")
	self.add_child(world)
