extends Spawner
const capitalist_ship      = preload("res://scenes/enemy/classic_world/ships/capitalist_ship.tscn")
const trash_ship           = preload("res://scenes/enemy/classic_world/ships/trash_ship.tscn")
const gun_ship            = preload("res://scenes/enemy/classic_world/ships/gun_ship.tscn")
const pirate_ship          = preload("res://scenes/enemy/classic_world/ships/pirate_ship.tscn")
const swimmer_ship         = preload("res://scenes/enemy/classic_world/ships/swimmer_ship.tscn")
const orca                 = preload("res://scenes/enemy/classic_world/ships/orca_spawner.tscn")
@export var max_entities : int = 30
var entities_spawned : int
var score : int
@onready var world : Node2D = get_parent()


# Handles spawning enemies
func spawn_new_enemy() -> void:
	# this part controls how fast the ship timer should be
	
	score = world.score
	var potential_time_left : int = int(wait_time - (score / 30.0))
	if (potential_time_left <= 1):
		potential_time_left = 1
	spawn_timer.wait_time = potential_time_left
	if entities_spawned >= max_entities:
		spawn_timer.start()
		return
	
	
	# so we can have ramping difficulty, so its harder enemies the further u go
	if score % 30 == 0 and score != 0:
		max_entities += 1
	var entity_index_to_spawn : int = randi_range(0,clamp(int(score / 5.0), 0, 5))
	var entity
	match entity_index_to_spawn:
		0:
			entity = trash_ship.instantiate()
		1:
			entity = capitalist_ship.instantiate()
		2:
			entity = gun_ship.instantiate()
			entity.min_fire_time = 5
			entity.max_fire_time = 10
		3:
			entity = pirate_ship.instantiate()
		4: 
			entity = swimmer_ship.instantiate()
		5:
			entity = orca.instantiate()
	entity = pirate_ship.instantiate()
	entity.set_global_scale(Vector2(2.0,2.0))
	entity.z_index = entities_spawned
	add_child(entity)
	spawn_timer.start()
	entities_spawned += 1
