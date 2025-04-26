extends Node2D
@onready var world      : Node2D
@onready var pause_menu : Control 



func _ready() -> void:
	global.world = world
	global.world_master = self
	world = load("res://scenes/world/main_menu/main_menu.tscn").instantiate()
	pause_menu = load("res://scenes/misc/pause_menu.tscn").instantiate()
	self.add_child(world)
	self.add_child(pause_menu)

# returns the current world id
func get_world_id() -> int:
	return world.world_id

# Changes what world/level we are on
func change_world(world_id : int) -> void:
	world.queue_free()
	global.player_master.delete_player()
	match world_id:
		0:
			world = load("res://scenes/world/main_menu/main_menu.tscn").instantiate()
			global.player_master.disable_player_starve_timer()
			global.player_master.disable_player_activity()
			global.music_master.change_song("midnight_sands")
		1:
			world = load("res://scenes/world/controls_menu/controls_screen.tscn").instantiate()
			global.player_master.change_player_global_position(Vector2(400,450))
			global.player_master.disable_player_starve_timer()
			global.player_master.enable_player_activity()
			global.player_master.change_player_scale(3)
		2:
			world = load("res://scenes/world/classic_world/beach_classic.tscn").instantiate()
			global.player_master.create_new_player(1 if save_master.save_data.get_value("settings", "smart_controls", false) else 0,true,true, false)
			global.player_master.change_player_scale(2)
			global.player_master.change_player_global_position(Vector2(800,650))
			global.music_master.change_song("lisa")
		3:
			world = load("res://scenes/world/classic_world/beach_guns.tscn").instantiate()
			global.player_master.create_new_player(1 if save_master.save_data.get_value("settings", "smart_controls", false) else 0, false, true, false)
			global.player_master.change_player_scale(2)
			global.player_master.change_player_global_position(Vector2(800,650))
			global.music_master.change_song("lisa")
		4:
			world = load("res://scenes/world/classic_world/beach_shadows.tscn").instantiate()
			global.player_master.create_new_player(1 if save_master.save_data.get_value("settings", "smart_controls", false) else 0, true, true, true)
			global.player_master.change_player_scale(2)
			global.player_master.change_player_global_position(Vector2(800,650))
			global.music_master.change_song("nighttime_solitude")
		
	call_deferred("add_child", world)
	## Doing this for legacy code
	global.player_master.change_player_world(get_world_id())
	global.world = world

#Resets the world, this is called when we die and we need to reset both player & world
func reset_world() -> void:
	global.player_master.create_new_player(1 if save_master.save_data.get_value("settings", "smart_controls", false) else 0, true, true)
	change_world(get_world_id())
