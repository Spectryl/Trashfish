extends Node2D
const spawnable_drop1 = preload("res://scenes/enemy/classic_world/drops/honey_drop.tscn")
const spawnable_drop2 = preload("res://scenes/enemy/classic_world/drops/ice_drop.tscn")

@onready var animated_sprite : AnimatedSprite2D = get_node("AnimatedSprite2D")
@onready var ship_component  : Node2D           = get_node("ship_component")
@onready var wait_timer      : Timer            = get_node("ship_component/wait_timer")
@onready var water_layer     : AnimatedSprite2D = get_node("water_layer")
func _ready() -> void:
	animated_sprite.play("default")
	ship_component.counter += randi_range(0,3)
	ship_component.speed += randi_range(0,250)
	wait_timer.wait_time = randi_range(0,1) + $ship_component.wait_time
