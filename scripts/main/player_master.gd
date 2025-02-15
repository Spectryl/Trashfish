extends Node2D
var player : CharacterBody2D

const player_scene = preload("res://scenes/player/player.tscn")
func _ready() -> void:
	player = player_scene.instantiate()
	global.player = player
	global.player_master = self
	self.add_child(player)
	disable_player_activity()

func set_player_defaults(new_scale: float = 1, new_speed : float = 200, new_global_position : Vector2 = Vector2(0,0), new_world_id : int = 0):
	change_player_scale(new_scale)
	change_player_speed(new_speed)
	change_player_global_position(new_global_position)
	change_player_world(new_world_id)

# changes the player scale based on what world we are changing to
func change_player_scale(new_value : float) -> void:
	player.set_global_scale(Vector2(new_value,new_value))
#func change_player_scale(new_value : Vector2):
	#player.set_global_scale(new_value)

# Changes the player's speed variable (this is permanent)
func change_player_speed(new_value : float) -> void:
	player.speed = new_value

# Changes the player's global position (use this when we change worlds)
func change_player_global_position(new_position : Vector2) -> void:
	player.global_position = new_position

# Changes Player's world_id
func change_player_world(new_id : int) -> void:
	player.world_id = new_id

# Disables the player's starve timer, use this for non-play areas
func disable_player_starve_timer() -> void:
	player.starve_timer.stop()

# Enables the player's starve timer, use this for play areas
func enable_player_starve_timer() -> void:
	player.starve_timer.start()
	player.starve = player.max_starve

# disables the player completely on screens & hides them
func disable_player_activity() -> void:
	player.set_process(false)
	player.visible = false
	player.body_hurtbox.set_deferred("disabled", true)

#Enables a player, use this on play-areas
func enable_player_activity() -> void:
	player.set_process(true)
	player.visible = true
	player.body_hurtbox.set_deferred("disabled", false)
	
func new_player(index : int, starve : bool = false, active : bool = false) -> void:
	player.queue_free()
	match index:
		0:
			player = player_scene.instantiate()
	global.player = player
	add_child(player)
	@warning_ignore("standalone_ternary")
	enable_player_starve_timer() if starve else disable_player_starve_timer()
	@warning_ignore("standalone_ternary")
	enable_player_activity()     if active else disable_player_activity()
	
	
		
