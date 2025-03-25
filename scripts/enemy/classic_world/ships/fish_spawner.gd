extends Node2D
@onready var sprite : Sprite2D = $Sprite2D

@export var enemies_left : int = 1
@export var fish_returned : int = 0
var state : int = 0
var fish
const play_slot_scene = preload("res://scenes/enemy/classic_world/ships/orca.tscn")
func _ready():
	# Spawn on left or right side of screen
	match randi_range(0,1):
		0:
			global_position.x = 50
		1:
			global_position.x = 1870
	global_position.y = randi_range(0,500) + 400
	$start_timer.start(5)
	$flash_timer.start()


func _process(_delta):
	match state:
		# We are still starting here
		0:
			return
		# Spawn the fish we need to
		1:
			for i in range(enemies_left, 0, -1):
				fish = play_slot_scene.instantiate()
				add_child(fish)
			state = 2
		2:
			if enemies_left <= fish_returned:
				get_parent().entities_spawned -= 1
				print("All Orca's have returned!, despawning spawner")
				queue_free()

# Handles the flashing effect of the spawner
func _on_flash_timer_timeout() -> void:
	sprite.visible = !sprite.visible
	# Handles cases for if this timer goes after we swap states
	if state == 0:
		$flash_timer.start()
	else:
		sprite.visible = false

# Handles swapping to State 1
func _on_start_timer_timeout() -> void:
	self.state = 1
	sprite.visible = false
