extends Node2D
@export var timer_length : float
@export var delete_timer_length : float
@export var particle_timer_length : float = 0.01
@export var fall_speed : int

var rotation_speed : float
var horizontal_distance_component : float

var isActive : bool = true
var active_timer : Timer
var delete_timer: Timer
var particle_timer: Timer
var xDirection : float
var ship_component : Node2D
var parent : Node2D
func _ready() -> void:
	
	ship_component = get_parent().get_parent().ship_component
	parent = get_parent()
	
	xDirection = cos(randi() % 4)
	active_timer = Timer.new()
	active_timer.wait_time = timer_length
	active_timer.one_shot = true
	add_child(active_timer)
	active_timer.timeout.connect(_on_active_timer_timeout)
	active_timer.start()
	
	delete_timer = Timer.new()
	delete_timer .wait_time = delete_timer_length
	delete_timer .one_shot = true
	add_child(delete_timer)
	delete_timer .timeout.connect(_on_delete_timer_timeout)
	active_timer.start()
	get_parent().global_position.y = get_parent().global_position.y + 50

	if particle_timer_length != 0.01:
		particle_timer = Timer.new()
		particle_timer.wait_time = particle_timer_length
		particle_timer.one_shot = true
		add_child(particle_timer)
		particle_timer.timeout.connect(_on_particle_timer_timeout)
	
	# stores the horizontal part so we don't need to keep calculating it
	horizontal_distance_component = xDirection * (fall_speed * 1.5) * -1.0
	
	# determines the rotation speed based on the falling speed
	rotation_speed = (abs(horizontal_distance_component) / 62.0)
		
	# determines which direction the drop will rotate
	match xDirection * -1.0 < 0:
		true: rotation_speed *= -1
		false: pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not isActive:
		return
	parent.global_position.x += horizontal_distance_component * delta
	parent.global_position.y += fall_speed * delta
	parent.rotation_degrees += rotation_speed
	

# On timer timeout, call the parents Event
func _on_active_timer_timeout() -> void:
	# if we have a particle event, this will proc it.  The particle event will then call the delete_timer
	if particle_timer_length != 0.01:
		particle_timer.start()
	else:
		delete_timer.start()
	isActive = false
	parent.timer_timeout_event()


func _on_particle_timer_timeout() -> void:
	delete_timer.start()
func _on_delete_timer_timeout() -> void:

	if parent.get_parent() == null:
		parent.queue_free()
	# Karl Jacobs Check
	if self.ship_component.id == 4:
		self.parent.get_parent().animated_sprite.play("default")
	
	ship_component.counter += -1
	ship_component.state = 0
	ship_component.hasWaited = false
	parent.queue_free()
