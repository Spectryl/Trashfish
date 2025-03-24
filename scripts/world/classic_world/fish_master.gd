extends Spawner
var current_entities : int = 0
@export var max_entities : int = 30

const baby_fish = preload("res://scenes/enemy/misc/baby_fish.tscn")

func spawn_new_enemy() -> void:
	if max_entities <= current_entities:
		spawn_timer.start()
		return
	
	add_child( baby_fish.instantiate() )
	spawn_timer.start()
	current_entities += 1
