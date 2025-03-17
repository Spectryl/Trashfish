extends CharacterBody2D
@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D

@export var speed : int = 150
var endPos : Vector2
var angle : float
var direction : Vector2
var parent  : Node2D
var parentX : int
var parentY : int

var distance
func _ready() -> void:
	parent  = get_parent()
	parentX = parent.global_position.x
	parentY = parent.global_position.y
	speed += randi_range(0,50)
	if parentX == 50:
		endPos.x = 2000
		endPos.y =  randi_range(0,700)  + 250
		global_position.x = -100
		global_position.y =  parentY
	else:
		endPos.x = -100
		endPos.y =  randi_range(0,700) + 250
		global_position.x = 2000
		global_position.y =  parentY
		animated_sprite.flip_h = true
	
	angle = global_position.angle_to_point(endPos)
	direction = Vector2(cos(angle), sin(angle)) 
	distance = direction * speed
	animated_sprite.play("default")
func _process(delta) -> void:
	global_position += distance * delta
	if global_position.x > 2000 or global_position.x < -100:
		parent.fish_returned += 1
		call_deferred("queue_free")


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.decrease_health()
	if body.is_in_group("baby_fish"):
		body.call_deferred("queue_free")
