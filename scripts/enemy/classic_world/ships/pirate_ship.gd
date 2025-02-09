extends Node2D
const spawnable_drop1 = preload("res://scenes/enemy/classic_world/drops/honey_drop.tscn")
const spawnable_drop2 = preload("res://scenes/enemy/classic_world/drops/ice_drop.tscn")

@onready var animated_sprite : AnimatedSprite2D = get_node("AnimatedSprite2D")
@onready var ship_component  : Node2D           = get_node("ship_component")
@onready var wait_timer      : Timer            = get_node("ship_component/wait_timer")
@onready var water_layer     : AnimatedSprite2D = get_node("water_layer")
@onready var flag            : AnimatedSprite2D = get_node("flag")
@onready var pirate          : AnimatedSprite2D = get_node("pirate")
var isMoving : bool = true: set = changeState
func _ready() -> void:
	animated_sprite.play("default")
	flag.play("default")
	water_layer.play("default")
	ship_component.counter += randi_range(0,3)
	ship_component.speed += randi_range(0,250)
	wait_timer.wait_time = randi_range(0,1) + ship_component.wait_time
	var window = load("res://scenes/enemy/classic_world/ships/pirate_ship_window.tscn")
	for i in range(randi_range(0,3)):
		var new_window = window.instantiate()
		new_window.position = Vector2(-27 + randi_range(0,60),randi_range(-20,-8))
		new_window.z_index = 1
		add_child(new_window)

func flip():
	animated_sprite.flip_h = !animated_sprite.flip_h
	water_layer.flip_h     = !water_layer.flip_h
	flag.position.x        *= -1
	flag.flip_h            = !flag.flip_h
	pirate.position.x      *= -1
	pirate.flip_h          = !pirate.flip_h

func changeState(new_value : bool):
	isMoving = new_value
	water_layer.visible = isMoving
	@warning_ignore("standalone_ternary")
	pirate.play("default") if isMoving else pirate.play("default")

func get_drop() -> void:
	var drop
	match randi_range(0,1):
			0:
				drop = spawnable_drop1.instantiate()
			_:
				drop = spawnable_drop2.instantiate()
	add_child(drop)
