extends CharacterBody2D

@onready var head : AnimatedSprite2D              = $head
@onready var tail : Sprite2D                      = $tail
@onready var garbage_can : Sprite2D               = $garbage_can
@onready var animation_player : AnimationPlayer   = $AnimationPlayer
@onready var navigation_agent : NavigationAgent2D = $NavigationAgent2D

var speed : int = 400
var acceleration = 15

func _ready() -> void:
	var random_color: Color = Color8(randi_range(0,255), randi_range(0,255), randi_range(0,255), 255)
	navigation_agent.set_avoidance_priority(randf_range(0,1))
	head.modulate = random_color
	tail.modulate = random_color
	_on_navigation_agent_2d_navigation_finished()

func _physics_process(delta: float) -> void:
	
	

	var direction : Vector2 = (navigation_agent.get_next_path_position() - global_position).normalized()
	
	navigation_agent.set_velocity(Vector2(
		lerp(velocity.x, speed * direction.x, acceleration * delta),
		lerp(velocity.y, speed * direction.y * 0.45, acceleration * delta)
	))

	
	
	match velocity.x > 0:
		true:
			animation_player.play("swim_right")
		_:
			animation_player.play("swim_left")

	

	
func _on_navigation_agent_2d_navigation_finished() -> void:
	navigation_agent.target_position = Vector2(randf_range(100, 1820), randf_range(300,900))
	
	

func attacked() -> void:
	call_deferred("queue_free")
		


func _on_navigation_agent_2d_velocity_computed(safe_velocity:Vector2) -> void:
	velocity = safe_velocity
	move_and_slide()
