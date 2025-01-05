extends Node2D
const spawnable_drop1 = preload("res://scenes/enemy/classic_world/drops/recycle_drop.tscn")
const spawnable_drop2 = preload("res://scenes/enemy/classic_world/drops/trash_drop.tscn")
#const spawnable_drop2 = preload("res://scenes/enemy/heart_drop.tscn")
@onready var animated_sprite : AnimatedSprite2D = get_node("AnimatedSprite2D")
@onready var ship_component  : Node2D           = get_node("ship_component")
@onready var wait_timer      : Timer            = get_node("ship_component/wait_timer")
@onready var front_water     : CPUParticles2D   = get_node("front_water_particles")
@onready var back_water      : CPUParticles2D   = get_node("back_water_particles")
var parent_score : int
func _ready() -> void:
	parent_score = get_parent().score
	# as the game goes on, the chandler ship will drop less and less point trash, this is counteracted since there will be more of them
	match int(parent_score / 20.0):
		0:
			ship_component.counter += randi() % 6
		1:
			ship_component.counter += randi() % 5
		2:
			ship_component.counter += randi() % 4
		3:
			ship_component.counter += randi() % 3
		_: 
			ship_component.counter += randi() % 2
	
	animated_sprite.play("default")
	ship_component.speed += randi() % 55
	wait_timer.wait_time = randi() % 2 + ship_component.wait_time
