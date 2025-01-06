extends Node2D
const spawnable_drop1 = preload("res://scenes/enemy/classic_world/drops/dynamite_drop.tscn")
const spawnable_drop2 = preload("res://scenes/enemy/classic_world/drops/honey_drop.tscn")
const spawnable_drop3 = preload("res://scenes/enemy/classic_world/drops/ice_drop.tscn")
const spawnable_drop4 = preload("res://scenes/enemy/classic_world/drops/recycle_drop.tscn")
const spawnable_drop5 = preload("res://scenes/enemy/classic_world/drops/trash_drop.tscn")
const spawnable_drop6 = preload("res://scenes/enemy/classic_world/drops/heart_drop.tscn")

@onready var animated_sprite : AnimatedSprite2D = get_node("AnimatedSprite2D")
@onready var ship_component  : Node2D           = get_node("ship_component")
@onready var wait_timer      : Timer            = get_node("ship_component/wait_timer")
@onready var water_layer     : AnimatedSprite2D = get_node("water_layer")
func _ready() -> void:
	animated_sprite.play("default")
	ship_component.counter += randi() % 5 #30 Under 30 Congrats Karl!... About that 30, NAHHHHHHH TO MUCH RNG
	ship_component.speed += randi() % 750
	wait_timer .wait_time = randi() % 1 + ship_component.wait_time
