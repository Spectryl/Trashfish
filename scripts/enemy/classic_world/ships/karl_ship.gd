extends Node2D
const spawnable_drop1 = preload("res://scenes/enemy/classic_world/drops/dynamite_drop.tscn")
const spawnable_drop2 = preload("res://scenes/enemy/classic_world/drops/honey_drop.tscn")
const spawnable_drop3 = preload("res://scenes/enemy/classic_world/drops/ice_drop.tscn")
const spawnable_drop4 = preload("res://scenes/enemy/classic_world/drops/recycle_drop.tscn")
const spawnable_drop5 = preload("res://scenes/enemy/classic_world/drops/trash_drop.tscn")
const spawnable_drop6 = preload("res://scenes/enemy/classic_world/drops/heart_drop.tscn")
const spawnable_drop7 = preload("res://scenes/enemy/classic_world/drops/nuclear_drop.tscn")
@onready var animated_sprite : AnimatedSprite2D = get_node("AnimatedSprite2D")
@onready var ship_component  : Node2D           = get_node("ship_component")
@onready var wait_timer      : Timer            = get_node("ship_component/wait_timer")
@onready var water_layer     : AnimatedSprite2D = get_node("water_layer")
var isMoving : bool = true: set = changeState
func _ready() -> void:
	animated_sprite.play("default")
	ship_component.counter += randi_range(0,5)
	ship_component.speed += randi_range(0,750)
	wait_timer .wait_time = randi_range(0,1)  + ship_component.wait_time

func flip():
	animated_sprite.flip_h = !animated_sprite.flip_h
	water_layer.flip_h     = !water_layer.flip_h

func changeState(new_value : bool):
	isMoving = new_value
	water_layer.visible = isMoving
