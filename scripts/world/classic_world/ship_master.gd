extends Node2D
const capitalist_ship      = preload("res://scenes/enemy/classic_world/ships/capitalist_ship.tscn")
const trash_ship           = preload("res://scenes/enemy/classic_world/ships/trash_ship.tscn")
const raft_ship            = preload("res://scenes/enemy/classic_world/ships/raft_enemy.tscn")
const pirate_ship          = preload("res://scenes/enemy/classic_world/ships/pirate_ship.tscn")
const swimmer_ship         = preload("res://scenes/enemy/classic_world/ships/swimmer_ship.tscn")
const orca                 = preload("res://scenes/enemy/classic_world/ships/fish_spawner.tscn")
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
	
	var difficulty_check : int = int(score / 5.0) # Determines how much we should range
	
	if score % 30 == 0 and score != 0:
		max_entities += 1
	if difficulty_check > 6:
		difficulty_check = 6
	if difficulty_check <= 0:
		difficulty_check = 1
	var entity_index_to_spawn : int = randi_range(0,difficulty_check)
	var entity
	match entity_index_to_spawn:
		0:
			entity = trash_ship.instantiate()
		1:
			entity = capitalist_ship.instantiate()
		2:
			entity = raft_ship.instantiate()
		3:
			entity = pirate_ship.instantiate()
		4: 
			entity = swimmer_ship.instantiate()
		5:
			entity = orca.instantiate()
	entity.set_global_scale(Vector2(2.0,2.0))
	entity.z_index = entities_spawned
	add_child(entity)
	timer.start()
	entities_spawned += 1
