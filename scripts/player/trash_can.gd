extends Node2D
@export var rotation_speed : int = 0
@export var timer_start : float = 0
@export var fall_speed : int = 0
var timer : Timer
var delete_timer : Timer
func _ready() -> void:
	global_position.x = -1000
	timer = Timer.new()
	timer.wait_time = timer_start
	timer.one_shot = true
	add_child(timer)
	timer.timeout.connect(_on_active_timer_timeout)
	timer.start()


func _process(delta: float) -> void:
	rotation_degrees += rotation_speed * delta
	global_position.y += fall_speed * delta

func _on_active_timer_timeout() -> void:
	global_position = global.player.global_position
	
