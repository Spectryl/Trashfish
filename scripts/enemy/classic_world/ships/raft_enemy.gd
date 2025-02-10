extends Node2D
const spawnable_drop = preload("res://scenes/enemy/classic_world/drops/bullet.tscn")

@onready var animated_sprite : AnimatedSprite2D = get_node("AnimatedSprite2D")
@onready var ship_component  : Node2D           = get_node("ship_component")
@onready var wait_timer      : Timer            = get_node("ship_component/wait_timer")
@onready var water_layer     : AnimatedSprite2D = get_node("water_layer")
@onready var flag            : AnimatedSprite2D = get_node("flag")
@onready var gunman          : AnimatedSprite2D = get_node("gunman")
@onready var gun             : AnimatedSprite2D = get_node("gunman/gun")
var isMoving : bool = true: set = changeState
var nextX : int
var speed : int
var state : int = 0
func _ready() -> void:
	animated_sprite.play("default")
	flag.play("default")
	water_layer.play("default")
	gunman.play("default")
	gun.visible = false
	ship_component.counter += randi_range(0,3)
	ship_component.speed += randi_range(0,250)
	wait_timer.wait_time = randi_range(0,1) + ship_component.wait_time

func flip():
	animated_sprite.flip_h = !animated_sprite.flip_h
	water_layer.flip_h     = !water_layer.flip_h
	flag.position.x        *= -1
	#flag.flip_h            = !flag.flip_h
	gunman.position.x      *= -1
	gunman.flip_h          = !gunman.flip_h

func _process(delta):
	if isMoving:
		return
	gun.set_gun_rotation()
	gunman.position.x += speed * delta
	if check_in_range(gunman.position.x, nextX, speed * delta):
		speed = 0
		state = 2
		gunman.play("jump")

func changeState(new_value : bool):
	isMoving = new_value
	water_layer.visible = isMoving
	gunman.play("default") if isMoving else gunman.play("wake_up")

func get_drop() -> void:
	var drop = spawnable_drop.instantiate()
	add_child(drop)


func _on_gunman_animation_finished() -> void:

	match gunman.animation:
		"wake_up":
			if state == 0:
				state = 1
				state_machine()
		"jump":
			if state == 2:
				state = 3
				state_machine()

func state_machine() -> void:
	match state:
		1:
			gunman.play("walk")
			print(gunman.animation)
			nextX = randi_range(-50, 20)
			speed = 50
			speed = abs(speed) * -1 if nextX < gunman.position.x else speed
			gunman.flip_h = speed < 0
		3:
			gunman.play("lying_down")
			gun.visible = true
			ship_component.wait_timer(2)

func check_in_range(a : float, b : float , range_of_pos : float) -> bool:
	return abs(a - b) < range_of_pos + 1
