extends Node2D
@onready var world      : Node2D
@onready var pause_menu : Control = $pause_menu



func _ready() -> void:
	global.world = world
	global.world_master = self
	world = load("res://scenes/world/main_menu/main_menu.tscn").instantiate()
	self.add_child(world)

# returns the current world id
func get_world_id() -> int:
	return world.world_id

# Changes what world/level we are on
func change_world(world_id : int) -> void:
	world.queue_free()
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
			world = load("res://scenes/world/classic_world/world.tscn").instantiate()
			global.player_master.enable_player_activity()
			global.player_master.change_player_scale(2)
			global.player_master.enable_player_starve_timer()
			global.player_master.change_player_global_position(Vector2(800,650))
			global.music_master.change_song("lisa")
	call_deferred("add_child", world)
	global.player_master.change_player_world(get_world_id())
	global.world = world

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if get_world_id() == 0 or get_world_id() == 1:
			return
		pause_menu.visible = true
		get_tree().paused = true
