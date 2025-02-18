extends Node2D
var speed : int = 200
var direction : Vector2
var gun_ship : Node2D
func _ready() -> void:
	speed += randi_range(0,105)
	set_rotation(gun_ship.gun.get_rotation())
	global_position = gun_ship.gun.get_global_position()
	direction = Vector2(cos(get_rotation()), sin(get_rotation())) * speed
	scale = Vector2(2,2)

func _process(delta : float) -> void:
	global_position +=  direction * delta
	if abs(global_position.x) > 2000 or abs(global_position.y) > 1200:
		call_deferred("queue_free")
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.decrease_health()
