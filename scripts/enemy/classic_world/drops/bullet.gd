extends Node2D
var speed : int = 200
var direction : Vector2
@onready var raft_enemy = get_parent()
func _ready() -> void:
	speed += randi_range(0,55)
	set_rotation(raft_enemy.gun.get_rotation())
	global_position = raft_enemy.gun.get_global_position()
	#raft_enemy.shoot_timer.start(10)
	direction = Vector2(cos(get_rotation()), sin(get_rotation())) * speed

func _process(delta : float) -> void:
	global_position +=  direction * delta
	if abs(global_position.x) > 2000 or abs(global_position.y) > 1200:
		raft_enemy.counter -= 1
		call_deferred("queue_free")
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.decrease_health()
