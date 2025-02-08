extends Node2D
const spawnable_drop = preload("res://scenes/enemy/classic_world/drops/dynamite_drop.tscn")


@onready var animated_sprite : AnimatedSprite2D = get_node("AnimatedSprite2D")
@onready var ship_component  : Node2D           = get_node("ship_component")
@onready var wait_timer      : Timer            = get_node("ship_component/wait_timer")
@onready var water_layer     : AnimatedSprite2D = get_node("water_layer")
@onready var flag            : AnimatedSprite2D = get_node("flag")
@onready var smoke           : AnimatedSprite2D = get_node("smoke")
@onready var logo            : Sprite2D         = get_node("logo")
@onready var josh            : AnimatedSprite2D = get_node("josh")
var isMoving : bool = true: set = changeState
var parent_score : int
func _ready() -> void:
	parent_score = get_parent().score
	animated_sprite.play("default")
	water_layer.play("default")
	flag.play("default")
	smoke.play("default")
	josh.play("default")
	ship_component.counter += randi_range(0,int(2 + parent_score / 100.0) )
	ship_component.speed += randi_range(0,30)
	wait_timer.wait_time = randi_range(0,3) + ship_component.wait_time

func flip():
	animated_sprite.flip_h = !animated_sprite.flip_h
	water_layer.flip_h     = !water_layer.flip_h
	flag.position.x        *= -1
	flag.flip_h            = !flag.flip_h
	smoke.position.x       *= -1
	smoke.flip_h           = !smoke.flip_h
	logo.position.x        *= -1
	josh.position.x        *= -1
	josh.flip_h            = !josh.flip_h

func changeState(new_value : bool):
	isMoving = new_value
	water_layer.visible = isMoving
	smoke.visible = isMoving
	@warning_ignore("standalone_ternary")
	josh.play("default") if isMoving else josh.play("idle")
	

func get_drop() -> void:
	add_child(spawnable_drop.instantiate())
