extends Node2D
@onready var world : Node2D

const main_menu_scene    = preload("res://scenes/world/main_menu/main_menu.tscn")
const control_menu_scene = preload("res://scenes/world/controls_menu/controls_screen.tscn")
const beach_world_scene  = preload("res://scenes/world/classic_world/world.tscn")


func _ready() -> void:
	global.world = world
	global.world_master = self
	world = main_menu_scene.instantiate()
	self.add_child(world)

# returns the current world id
func get_world_id() -> int:
	return world.world_id

# Changes what world/level we are on
func change_world(world_id : int) -> void:
	world.queue_free()
	match world_id:
		0:
			world = main_menu_scene.instantiate()
			global.player_master.disable_player_starve_timer()
			global.player_master.disable_player_activity()
			global.music_master.change_song("midnight_sands")
		1:
			world = control_menu_scene.instantiate()
			global.player_master.change_player_global_position(Vector2(400,450))
			global.player_master.disable_player_starve_timer()
			global.player_master.enable_player_activity()
			global.player_master.change_player_scale(3.0)
			
		2:
			world = beach_world_scene.instantiate()
			global.player_master.enable_player_activity()
			global.player_master.change_player_scale(2.0)
			global.player_master.enable_player_starve_timer()
			global.player_master.change_player_global_position(Vector2(800,650))
			global.music_master.change_song("lisa")
	call_deferred("add_child", world)
	global.player_master.change_player_world(get_world_id())
