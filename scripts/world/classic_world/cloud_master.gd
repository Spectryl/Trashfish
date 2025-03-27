extends Spawner

const cloud = preload("res://scenes/enemy/misc/cloud.tscn")

func _ready() -> void:
	match randi_range(0,50):
		0,1,2,3,4,5:
			print("Today is a cloudy day")
			wait_time = 1
		6,7,8,9,10:
			print("I guess it is not a cloudy day")
			call_deferred("queue_free")
		_:
			print("Normal Weather day")
			pass
	super._ready()
# @Override
func spawn_new_enemy() -> void:
	var new_cloud : Node2D = cloud.instantiate()
	new_cloud.set_global_scale(Vector2(2.0,2.0))
	add_child(new_cloud)
	spawn_timer.start()
