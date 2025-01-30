extends Node2D
const spawnable_drop1 = preload("res://scenes/enemy/classic_world/drops/recycle_drop.tscn")
const spawnable_drop2 = preload("res://scenes/enemy/classic_world/drops/trash_drop.tscn")
#const spawnable_drop2 = preload("res://scenes/enemy/heart_drop.tscn")
#const spawnable_drop2 = preload("res://scenes/enemy/classic_world/drops/nuclear_drop.tscn")
@onready var animated_sprite : AnimatedSprite2D = get_node("AnimatedSprite2D")
@onready var ship_component  : Node2D           = get_node("ship_component")
@onready var wait_timer      : Timer            = get_node("ship_component/wait_timer")
@onready var water_layer     : AnimatedSprite2D = get_node("water_layer")
@onready var smoke           : AnimatedSprite2D = $smoke
var parent_score : int
var isMoving : bool = true: set = changeState
func _ready() -> void:
	water_layer.play("default")
	smoke.play("default")
	parent_score = get_parent().score
	# as the game goes on, the chandler ship will drop less and less point trash, this is counteracted since there will be more of them
	match int(parent_score / 20.0):
		0:
			ship_component.counter += randi_range(0,6)
		1:
			ship_component.counter += randi_range(0,5)
		2:
			ship_component.counter += randi_range(0,4)
		3:
			ship_component.counter += randi_range(0,3)
		_: 
			ship_component.counter += randi_range(0,2)
	
	animated_sprite.play("default")
	ship_component.speed += randi_range(0,55)
	wait_timer.wait_time = randi_range(0,2) + ship_component.wait_time

func flip(value : bool):
	animated_sprite.flip_h = value
	water_layer.flip_h     = value
	smoke.position.x = abs(smoke.position.x) * (-1 if value else 1)
	smoke.flip_h = value

func changeState(new_value : bool):
	isMoving = new_value
	water_layer.visible = isMoving
	smoke.visible = isMoving
	
	
