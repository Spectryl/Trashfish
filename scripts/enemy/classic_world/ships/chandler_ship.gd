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
@onready var crates          : Sprite2D         = $crates
@onready var kevin           : AnimatedSprite2D = $kevin
@onready var smoke_vent1     : AnimatedSprite2D = $trash_ship_smoke_vent
@onready var smoke_vent2     : AnimatedSprite2D = $trash_ship_smoke_vent2
var parent_score : int
var isMoving : bool = true: set = changeState

@export var pos1 : int = -58
@export var pos2 : int = 58
@export var speed : int = -50

func _ready() -> void:
	water_layer.play("default")
	smoke.play("default")
	kevin.play("idle")
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

func _process(delta: float) -> void:
	if isMoving:
		return
	kevin.position.x += speed * delta
	if kevin.position.x < pos1 or kevin.position.x > pos2:
		speed *= -1
		kevin.flip_h = false if speed < 0 else true
		

func flip():
	animated_sprite.flip_h = !animated_sprite.flip_h
	water_layer.flip_h     = !water_layer.flip_h
	smoke.position.x       *= -1
	smoke.flip_h           = !smoke.flip_h
	crates.flip_h          = !crates.flip_h
	crates.position.x      *= -1
	kevin.flip_h           = animated_sprite.flip_h
	kevin.position.x       *= -1
	smoke_vent1.flip_h     = !smoke_vent1.flip_h
	smoke_vent2.flip_h     = !smoke_vent2.flip_h
	smoke_vent1.position.x *= -1
	smoke_vent2.position.x *= -1
	speed *= -1

func changeState(new_value : bool):
	isMoving = new_value
	water_layer.visible = isMoving
	smoke.visible = isMoving
	@warning_ignore("standalone_ternary")
	kevin.play("idle") if isMoving else kevin.play("walk")
	kevin.position.x = 48 if crates.flip_h else -48
	
func evil_abs(value : int) -> int:
	return abs(value) * -1
	
