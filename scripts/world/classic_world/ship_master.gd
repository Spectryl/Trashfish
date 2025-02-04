extends Node2D
const beast_ship      = preload("res://scenes/enemy/classic_world/ships/mrbeast_ship.tscn")
const trash_ship      = preload("res://scenes/enemy/classic_world/ships/trash_ship.tscn")
const raft_ship       = preload("res://scenes/enemy/classic_world/ships/raft_enemy.tscn")
const pirate_ship     = preload("res://scenes/enemy/classic_world/ships/pirate_ship.tscn")
const swimmer_ship    = preload("res://scenes/enemy/classic_world/ships/swimmer_ship.tscn")
const orca            = preload("res://scenes/enemy/classic_world/ships/fish_spawner.tscn")
@export var timer_wait_time : float
@export var max_entities : int = 30
var entities_spawned : int
var score : int
var timer : Timer
@onready var world : Node2D = get_parent()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	self.timer = Timer.new()
	self.timer.wait_time = timer_wait_time
	self.timer.one_shot = true
	self.add_child(timer)
	self.timer.timeout.connect(_on_delete_timer_timeout)
	timer.start(1) #This is so the world's Global.world is set properly so everything reliant on that one variable is set properly
	


func _on_delete_timer_timeout() -> void:
	score = world.score
	var a = int(timer_wait_time - (score / 30.0))
	if (a <= 1):
		a = 1
	self.timer.wait_time = a
	if entities_spawned >= max_entities:
		self.timer.start()
		return
	spawn_new_enemy()


# Handles spawning enemies
func spawn_new_enemy() -> void:
	# so we can have ramping difficulty, so its harder enemies the further u go
	
	var c = int(score / 5.0)
	
	if score % 30 == 0 and score != 0:
		max_entities += 1
	if c > 6:
		c = 6
	if c <= 0:
		c = 1
	var a : int = randi() % c
	var b
	match a:
		0:
			b = trash_ship.instantiate()
		1:
			b = beast_ship.instantiate()
		2:
			b = raft_ship.instantiate()
		3:
			b = pirate_ship.instantiate()
		4: 
			b = swimmer_ship.instantiate()
		5:
			b = orca.instantiate()
	b.set_global_scale(Vector2(2/8,2/8))
	add_child(b)
	timer.start()
	entities_spawned += 1
