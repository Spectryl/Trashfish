extends Node2D
@onready var raft = $raft
@onready var gun = $gun
@onready var shoot_timer = $shoot_timer
@onready var water_layer = $water_layer
@onready var state = 0

var nextX : float
var direction : int
var bullets_left : int = 2
@export var speed : int = 100
const play_slot_scene = preload("res://scenes/enemy/classic_world/drops/bullet.tscn")

func _ready() -> void:
	raft.play("idle")
	bullets_left += randi_range(0,3)
	speed += randi_range(0,150)
	match randi_range(0,1):
		0:
			self.global_position.x = -100
		1:
			self.global_position.x = 2000
	shoot_timer.wait_time += randi_range(0,10)
	water_layer.play("default")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	gun.set_gun_rotation()
	match state:
		0:
			nextX = randi_range(0,800) + 200
			state = 1
			direction = 1 if self.global_position.x - nextX  <= 0 else -1 # Go Left if we are to the right, otherwise go right
			self.flip()
			water_layer.visible = true
			return
		# We have a spot to go to but we aren't there yet
		1:
			self.global_position.x += direction * speed * delta
			if check_in_range(self.global_position.x,nextX, speed * delta):
				state = 2
			return
		# We have arrived at our spot fire!
		2:
			water_layer.visible = false
			if bullets_left == 0:
				state = 3
				shoot_timer.stop()
				return
			if shoot_timer.is_stopped():
				shoot_timer.start()
			return
		3:
			water_layer.visible = true
			nextX = randi_range(0,1)
			nextX = -100 if nextX == 0 else 2000
			direction = 1 if self.global_position.x - nextX  <= 0 else -1 # Go Left if we are to the right, otherwise go right
			state = 4
			return
		4:
			global_position.x += direction * speed * delta
			if check_in_range(global_position.x,nextX, speed * delta):
				state = 5
			flip()
			return
		# We are at our despawn position, so despawn
		5:
			get_parent().entities_spawned -= 1
			queue_free()

# After timer ends, have the gun fire a bullet towards the player and restart the timer
func _on_shoot_timer_timeout() -> void:
	gun.play("fire")
	global.sound_master.play("rifle_shot")
	bullets_left -= 1
	# safeguard so we don't fire extra bullets
	if bullets_left == 0:
		state = 3
		return
	var bullet = play_slot_scene.instantiate()
	add_child(bullet)
	
# Checks if value a/b are in range of each other
func check_in_range(a : float, b : float , range_of_value : float ) -> bool:
	if a > b:
		if a - b < range_of_value + 1:
			return true
	if a < b:
		if b - a < range_of_value + 1:
			return true
	return false

# Flips the ship and gun around
func flip():
	var old_direction = raft.flip_h
	raft.flip_h = true if direction == 1 else false
	if old_direction != raft.flip_h:
		gun.position.x *= -1
