extends Node2D
var spawn_timer : Timer
var current_entities : int
@export var wait_time : float = 7
@export var max_entities : int = 30

const baby_fish = preload("res://scenes/enemy/misc/baby_fish.tscn")


func _ready() -> void:
	spawn_timer = Timer.new()
	add_child(spawn_timer)
	spawn_timer.wait_time = wait_time
	spawn_timer.timeout.connect(spawn_new_enemy)
	spawn_timer.start(1)
	spawn_timer.wait_time = wait_time
	


func spawn_new_enemy() -> void:
	if max_entities <= current_entities:
		spawn_timer.start()
		return
	
	add_child( baby_fish.instantiate() )
	spawn_timer.start()
	current_entities += 1




