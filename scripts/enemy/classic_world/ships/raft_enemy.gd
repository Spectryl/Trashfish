extends Node2D
const spawnable_drop = preload("res://scenes/enemy/classic_world/drops/bullet.tscn")

@onready var animated_sprite : AnimatedSprite2D = get_node("AnimatedSprite2D")
@onready var ship_component  : Node2D           = get_node("ship_component")
@onready var wait_timer      : Timer            = get_node("ship_component/wait_timer")
@onready var water_layer     : AnimatedSprite2D = get_node("water_layer")
@onready var flag            : AnimatedSprite2D = get_node("flag")
@onready var gunman          : AnimatedSprite2D = get_node("gunman")
@onready var gun             : AnimatedSprite2D = get_node("gunman/gun")
@onready var shoot_timer     : Timer            = get_node("shoot_timer")

@export var min_fire_time    : float
@export var max_fire_time    : float
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
	var new_color = Color(randf_range(0,1), randf_range(0,1), randf_range(0,1), 1.0)
	gunman.material.set_shader_parameter("u_replacement_color", new_color)
func flip():
	animated_sprite.flip_h = !animated_sprite.flip_h
	water_layer.flip_h     = !water_layer.flip_h
	flag.position.x        *= -1
	gunman.position.x      *= -1
	gunman.flip_h          = !gunman.flip_h
func _process(delta):
	gun.set_gun_rotation()
	if isMoving or state == 2 or state == 3:
		return
	gunman.position.x += speed * delta
	if check_in_range(gunman.position.x, nextX, speed * delta):
		speed = 0
		state = 2
		gunman.play("jump")

func changeState(new_value : bool):
	isMoving = new_value
	water_layer.visible = isMoving
	if isMoving:
		gun.visible = false
	@warning_ignore("standalone_ternary")
	gunman.play("wake_up") if not isMoving and ship_component.state == 2 else gunman.play("default")

func get_drop() -> void:
	shoot_timer.start(2)


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
			nextX = randi_range(-50, 0)
			
			speed = 50
			speed = abs(speed) * -1 if nextX < gunman.position.x else speed
			gunman.flip_h = speed > 0
			#gun.flip_h = speed > 0
			gun.position.x *= -1 if gunman.flip_h else 1
		3:
			gunman.play("lying_down")
			gun.visible = true
			ship_component.wait_timer.start(2)

func check_in_range(a : float, b : float , range_of_pos : float) -> bool:
	return abs(a - b) < abs(range_of_pos) + 1

func _on_shoot_timer_timeout() -> void:
	if ship_component.counter < 0:
		shoot_timer.stop()
		ship_component.state = 3
		ship_component.counter = -1
		gun.visible = false
		return
	gun.play("fire")
	global.sound_master.play_gunshot()
	var bullet = spawnable_drop.instantiate()
	bullet.gun_ship = self
	get_parent().add_child(bullet)
	ship_component.counter -= 1
	shoot_timer.start(randf_range(min_fire_time,max_fire_time))

func flip_gunman() -> void:
	gunman.flip_h = !gunman.flip_h
	gun.flip_h    = !gun.flip_h
