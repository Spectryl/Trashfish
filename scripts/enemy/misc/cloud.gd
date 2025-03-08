extends Node2D
@onready var sprite : Sprite2D = $Sprite2D
@export  var speed : float = 50
var direction : int
var move_per_delta : float

var delete_timer : IntervalTimer

func _ready() -> void:

    match randi_range(0,50):
        0:
            sprite.texture = load("res://resources/objects/empty_cloud.tres")
        1:
            sprite.texture = load("res://resources/objects/cloud_face1.tres")
        2:
            sprite.texture = load("res://resources/objects/cloud_face2.tres")

    self_modulate = Color8(randi_range(0,255), randi_range(0,255), randi_range(0,255), 255)
    global_position = get_parent().global_position
    direction = 1 if randi_range(0,1) == 0 else -1
    speed = randf_range(25,125)
    move_per_delta = direction * speed
    delete_timer.new(self_deletion_check, 5)
    delete_timer.start()

func _physics_process(delta: float) -> void:
    global_position.x += move_per_delta * delta
    

func self_deletion_check() -> void:
    if global_position.x > 2000 or global_position.x < -100:
        self.call_deferred("queue_free")
    else:
        delete_timer.start()