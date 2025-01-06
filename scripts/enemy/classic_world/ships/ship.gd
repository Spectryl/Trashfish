extends Node2D
@export var counter : int = 3
@export var speed : int = 200
@export var id : int
@export var wait_time : float = 0.25
var state : int = 0
var nextX : float
var direction : int = 0
var hasWaited : bool = false
const death_timer = preload("res://scenes/misc/delete_component.tscn")
var drop
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.get_parent().global_position.y = get_parent().get_parent().global_position.y + randi() % 3
	match randi_range(0,1):
		0:
			self.get_parent().global_position.x = -100
		1:
			self.get_parent().global_position.x = 2000


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# IF we aren't moving and we aren't dropping items, then we should find a new spot to go
	match state:
		0:
			# this is for when we run out of things to drop so lets go to despawning state
			if self.counter < 0:
				state = 3
				return
			
			if self.id == 4 or self.id == 3:
				get_parent().animated_sprite.play("swim")
			nextX = randi() % 1300 + 450
			state = 1
			
			direction = 1 if get_parent().global_position.x - nextX  <= 0 else -1 # Go Left if we are to the right, otherwise go right
			get_parent().animated_sprite.flip_h = true if direction == 1 else false
			get_parent().water_layer.visible = true 
			
			
			return
		# We have a spot to go to but we aren't there yet
		1:
			self.get_parent().global_position.x += direction * speed * delta
			if check_in_range(self.get_parent().global_position.x,nextX, speed * delta):
				state = 2
				$wait_timer.start()
			return
		# We have arrived at our spot but we haven't dropped an item yet
		2:
			get_parent().water_layer.visible = false
			# Karl Jacobs has an additional animation
			if self.id == 4 or self.id == 3:
				get_parent().animated_sprite.play("default")
			# Wait for some time if we'd like
			if $wait_timer.time_left > 0.01 and not $wait_timer.is_stopped():
				return
			
			get_spawnable_drop()
			self.get_parent().add_child(drop)
			state = 3
			return
		# We have run out of things to drop, so lets' be set to despawn!
		3:
			
			if self.counter < 0:
				# Reset Karl Jacobs Animation
				if self.id == 4 or self.id == 3:
					self.get_parent().animated_sprite.play("swim")
				self.state = 4
				nextX = randi() % 2
				nextX = -100 if nextX == 0 else 2000
				direction = 1 if get_parent().global_position.x - nextX  <= 0 else -1 # Go Left if we are to the right, otherwise go right
			return
		# Move towards our despawn position
		4:
			get_parent().water_layer.visible = true
			self.get_parent().global_position.x += direction * speed * delta
			if check_in_range(self.get_parent().global_position.x,nextX, speed * delta):
				state = 5
			get_parent().animated_sprite.flip_h = true if direction == 1 else false
			return
		# We are at our despawn position, so despawn
		5:
			self.get_parent().get_parent().entities_spawned -= 1
			self.get_parent().queue_free()
			
	
# Gets what type of drop we need to drop from the parent then we can pass it to this component
func get_spawnable_drop():
	# For chandler/kris ships which need multiple drops
	if self.id == 2 or self.id == 3:
		match randi() % 2:
			0:
				drop = get_parent().spawnable_drop1.instantiate()
			1:
				drop = get_parent().spawnable_drop2.instantiate()
		return
	# Karl jacobs needs all the drops...
	if self.id == 4:
		match randi() % 6:
			0:
				drop = get_parent().spawnable_drop1.instantiate()
			1:
				drop = get_parent().spawnable_drop2.instantiate()
			2:
				drop = get_parent().spawnable_drop3.instantiate()
			3:
				drop = get_parent().spawnable_drop4.instantiate()
			4:
				drop = get_parent().spawnable_drop5.instantiate()
			5: 
				drop = get_parent().spawnable_drop6.instantiate()
		return
	
	drop = get_parent().spawnable_drop.instantiate()
	

func check_in_range(a : float, b : float , range_of_pos : float) -> bool:
	if a > b:
		if a - b < range_of_pos + 1:
			return true
	if a < b:
		if b - a < range_of_pos + 1:
			return true
	return false
		


func _on_wait_timer_timeout() -> void:
	hasWaited = true

# Deletes all the drops when we stop moving so it looks c l e a n
# turns out I was correct in my original report, this looks real jank but the problem is now inherently fixed instead of band-aid fixed
func delete_all_drop_children() -> void:
	for x in get_parent().get_children():
		#print(x)
		if x.is_in_group("drop"):
			x.queue_free()
			return #return since there is usually only 1 drop so we can just return to save time
			
		
