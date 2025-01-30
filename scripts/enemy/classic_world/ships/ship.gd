extends Node2D
@export var counter : int = 3
@export var speed : int = 200
@export var id : int
@export var wait_time : float = 0.25

@onready var parent = get_parent()
@onready var wait_timer = $wait_timer
var state : int = 0
var nextX : float
var direction : int = 0
var hasWaited : bool = false
var world : Node2D
const death_timer = preload("res://scenes/misc/delete_component.tscn")
var sound_timer : Timer
var stream_length : float
var drop
var sound_master : Node
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	parent.global_position.y = parent.get_parent().global_position.y + randi_range(0,3)
	world = global.world
	sound_timer = Timer.new()
	sound_master = global.sound_master
	stream_length = sound_master.wave_splash.stream.get_length()
	sound_timer.wait_time = stream_length
	sound_timer.one_shot  = false
	sound_timer.autostart = false
	sound_timer.timeout.connect(sound_timer_timeout_event)
	add_child(sound_timer)
	sound_timer.start(stream_length)
	match randi_range(0,1):
		0:
			parent.global_position.x = -100
		1:
			parent.global_position.x = 2000


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# IF we aren't moving and we aren't dropping items, then we should find a new spot to go
	match state:
		0:
			sound_timer.start(stream_length)
			sound_master.play("wave_splash")
			# this is for when we run out of things to drop so lets go to despawning state
			if counter < 0:
				state = 3
				return
			
			if id == 4 or id == 3:
				parent.animated_sprite.play("swim")
			nextX = randi_range(0,1300) + 450
			state = 1
			
			direction = 1 if parent.global_position.x - nextX  <= 0 else -1 # Go Left if we are to the right, otherwise go right
			parent.flip(true) if direction == 1 else parent.flip(false)
			parent.isMoving = true
			return
		# We have a spot to go to but we aren't there yet
		1:
			parent.global_position.x += direction * speed * delta
			if check_in_range(self.parent.global_position.x,nextX, speed * delta):
				state = 2
				wait_timer.start()
			return
		# We have arrived at our spot but we haven't dropped an item yet
		2:
			sound_timer.stop()
			parent.isMoving = false
			# Karl Jacobs has an additional animation
			if id == 4 or id == 3:
				parent.animated_sprite.play("default")
			# Wait for some time if we'd like
			if wait_timer.time_left > 0.01 and not wait_timer.is_stopped():
				return
			
			get_spawnable_drop()
			parent.add_child(drop)
			state = 3
			return
		# We have run out of things to drop, so lets' be set to despawn!
		3:
			
			if counter < 0:
				# Reset Karl Jacobs Animation
				if id == 4 or id == 3:
					parent.animated_sprite.play("swim")
				sound_master.play("wave_splash")
				sound_timer.start(stream_length)
				state = 4
				nextX = randi_range(0,1)
				nextX = -100 if nextX == 0 else 2000
				direction = 1 if parent.global_position.x - nextX  <= 0 else -1 # Go Left if we are to the right, otherwise go right
			return
		# Move towards our despawn position
		4:
			
			parent.isMoving = true
			parent.global_position.x += direction * speed * delta
			if check_in_range(parent.global_position.x,nextX, speed * delta):
				state = 5
			parent.flip(true) if direction == 1 else parent.flip(false)
			return
		# We are at our despawn position, so despawn
		5:
			parent.get_parent().entities_spawned -= 1
			parent.queue_free()
			
	
# Gets what type of drop we need to drop from the parent then we can pass it to this component
func get_spawnable_drop():
	# For chandler/kris ships which need multiple drops
	if id == 2 or id == 3:
		match randi_range(0,1):
			0:
				drop = parent.spawnable_drop1.instantiate()
			1:
				drop = parent.spawnable_drop2.instantiate()
		return
	# Karl jacobs needs all the drops...
	if id == 4:
		match randi_range(0,6):
			0:
				drop = parent.spawnable_drop1.instantiate()
			1:
				drop = parent.spawnable_drop2.instantiate()
			2:
				drop = parent.spawnable_drop3.instantiate()
			3:
				drop = parent.spawnable_drop4.instantiate()
			4:
				drop = parent.spawnable_drop5.instantiate()
			5: 
				drop = parent.spawnable_drop6.instantiate()
			6:
				drop = parent.spawnable_drop7.instantiate()
		return
	
	drop = parent.spawnable_drop.instantiate()
	

func check_in_range(a : float, b : float , range_of_pos : float) -> bool:
	return abs(a - b) < range_of_pos + 1

func sound_timer_timeout_event() -> void:
	sound_master.play("wave_splash")

func _on_wait_timer_timeout() -> void:
	hasWaited = true

# Deletes all the drops when we stop moving so it looks c l e a n
# turns out I was correct in my original report, this looks real jank but the problem is now inherently fixed instead of band-aid fixed
func delete_all_drop_children() -> void:
	for x in get_parent().get_children():
		if x.is_in_group("drop"):
			x.queue_free()
			return #return since there is usually only 1 drop so we can just return to save time
			
		
