extends Spawner

const cloud = preload("res://scenes/enemy/misc/cloud.tscn")


# @Override
func spawn_new_enemy() -> void:
	var new_cloud : Node2D = cloud.instantiate()
	new_cloud.set_global_scale(Vector2(2.0,2.0))
	add_child(new_cloud)
	spawn_timer.start()
