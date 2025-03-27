extends Spawner
const gun_ship            = preload("res://scenes/enemy/classic_world/ships/gun_ship.tscn")
@export var timer_wait_time : float
var entities_spawned : int



# Handles spawning enemies
func spawn_new_enemy() -> void:
	var entity = gun_ship.instantiate()
	entity.min_fire_time = randf_range(0,5)
	entity.max_fire_time = entity.min_fire_time + randf_range(0,5)
	entity.set_global_scale(Vector2(2.0,2.0))
	entity.z_index = entities_spawned
	add_child(entity)
	spawn_timer.start(timer_wait_time + randf_range(0,7.5))
	entities_spawned += 1
