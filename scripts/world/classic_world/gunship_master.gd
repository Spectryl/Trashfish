extends Node2D
const gun_ship            = preload("res://scenes/enemy/classic_world/ships/gun_ship.tscn")
@export var timer_wait_time : float
var timer : Timer
var entities_spawned : int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	timer = Timer.new()
	timer.wait_time = timer_wait_time + randf_range(0, 7.5)
	timer.one_shot = true
	add_child(timer)
	timer.timeout.connect(_on_delete_timer_timeout)
	timer.start(1) #This is so the world's Global.world is set properly so everything reliant on that one variable is set properly
	


func _on_delete_timer_timeout() -> void:
	spawn_new_enemy()


# Handles spawning enemies
func spawn_new_enemy() -> void:
	var entity = gun_ship.instantiate()

	entity.set_global_scale(Vector2(2.0,2.0))
	entity.z_index = entities_spawned
	add_child(entity)
	timer.start(timer_wait_time + randf_range(0, 7.5))
	entities_spawned += 1
