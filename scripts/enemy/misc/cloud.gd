extends Node2D
@onready var sprite : Sprite2D = $Sprite2D
@export  var speed : float = 50
var direction : int
var move_per_delta : float

var delete_timer : IntervalTimer

func _ready() -> void:

	match randi_range(0,50):
		0:
			sprite.texture = load("res://resources/objects/cloud_face1.tres")
		1:
			sprite.texture = load("res://resources/objects/cloud_face2.tres")
		_:
			sprite.texture = load("res://resources/objects/empty_cloud.tres")

	modulate = Color8(randi_range(220,255), randi_range(220,255), randi_range(220,255), 255)
	direction = 1 if randi_range(0,1) == 0 else -1
	global_position.x = -50 if direction == 1 else 1990
	global_position.y = randf_range(10,50)
	sprite.flip_h = 1 if direction == 1 else 0
	speed = randf_range(25,125)
	move_per_delta = direction * speed
	delete_timer = IntervalTimer.new(self_deletion_check, 5)
	add_child(delete_timer)
	delete_timer.start()

func _physics_process(delta: float) -> void:
	global_position.x += move_per_delta * delta
	

func self_deletion_check() -> void:
	if global_position.x > 2000 or global_position.x < -100:
		print("This Cloud is going to Queue_free")
		self.call_deferred("queue_free")
	else:
		delete_timer.start()
