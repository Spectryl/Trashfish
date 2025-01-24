extends Node2D
@onready var world : Node2D

const main_menu_scene    = preload("res://scenes/world/main_menu/main_menu.tscn")
const control_menu_scene = preload("res://scenes/world/main_menu/start_button.tscn")
const beach_world_scene  = preload("res://scenes/world/classic_world/world.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global.world = world
	world = main_menu_scene.instantiate()
	self.add_child(world)


# Changes what world/level we are on
func change_world(world_id : int):
	match world_id:
		0:
			world = main_menu_scene.instantiate()
		1:
			world = control_menu_scene.instantiate()
		2:
			world = beach_world_scene.instantiate()
