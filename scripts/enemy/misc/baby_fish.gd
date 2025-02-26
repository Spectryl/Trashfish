extends CharacterBody2D

@onready var head : AnimatedSprite2D              = $head
@onready var tail : Sprite2D                      = $tail
@onready var garbage_can : Sprite2D               = $garbage_can
@onready var animation_player : AnimationPlayer   = $AnimationPlayer
@onready var navigation_agent : NavigationAgent2D = $NavigationAgent2D
@onready var collision   : CollisionShape2D       = $CollisionShape2D
@onready var job_detection : CollisionShape2D     = $area_detection/CollisionShape2D
@onready var fish_master      : Node2D            = get_parent()

var attack_timer : Timer
var player_attack_cooldown_timer : Timer
enum fish_job {
	RANDOM,
	PLAYER,
	DROP,
	CRAB
}

var current_job : fish_job
var speed : int = 400
var acceleration : float = 15
var can_attack_player : bool = true
var stamina : int = 30

func _ready() -> void:
	var random_color: Color = Color8(randi_range(0,255), randi_range(0,255), randi_range(0,255), 255)
	navigation_agent.set_avoidance_priority(randf_range(0,1))
	head.modulate = random_color
	tail.modulate = random_color
	_on_navigation_agent_2d_navigation_finished()
	var r_scale = randf_range(1.85, 2.15)
	self.scale = Vector2(r_scale, r_scale)
	global_position.x = -100 if randi_range(0,1) == 1 else 2000
	global_position.y = 540
	attack_timer = Timer.new()
	attack_timer.wait_time = 5
	attack_timer.timeout.connect(attack_player)
	add_child(attack_timer)
	player_attack_cooldown_timer = Timer.new()
	player_attack_cooldown_timer.wait_time = 10
	player_attack_cooldown_timer.timeout.connect(reset_player_attack_cooldown)
	add_child(player_attack_cooldown_timer)
	

func _physics_process(delta: float) -> void:
	
	var direction : Vector2 = (navigation_agent.get_next_path_position() - global_position).normalized()
	navigation_agent.set_velocity(Vector2(
		lerp(velocity.x, speed * direction.x, acceleration * delta),
		lerp(velocity.y, speed * direction.y * 0.45, acceleration * delta)
	))
	handle_animations()
	work()



func handle_animations() -> void:
	
	match current_job:
		fish_job.PLAYER:
			animation_player.play("attacking")
			set_global_rotation(get_angle_to_player())

		fish_job.RANDOM:
			match velocity.x > 0:
				true:
					animation_player.play("swim_right")
				_:
					animation_player.play("swim_left")


func _on_navigation_agent_2d_navigation_finished() -> void:
	navigation_agent.target_position = Vector2(randf_range(100, 1820), randf_range(300,900))
	
func attacked() -> void:
	fish_master.current_entities -= 1
	call_deferred("queue_free")

func _on_navigation_agent_2d_velocity_computed(safe_velocity:Vector2) -> void:
	velocity = safe_velocity
	move_and_slide()


func _on_area_detection_body_entered(body:Node2D) -> void:
	if body.is_in_group("player") and can_attack_player:
		current_job = fish_job.PLAYER
		attack_timer.start()
		return
	if body.is_in_group("drop"):
		current_job = fish_job.DROP
		return

func _on_area_detection_body_exited(body:Node2D) -> void:
	if body.is_in_group("player"):
		current_job = fish_job.RANDOM
		attack_timer.stop()
		set_global_rotation(0)
		return

func work() -> void:
	match current_job:
		fish_job.PLAYER:
			navigation_agent.target_position = global.player.global_position

## Returns stamina on hand of baby fish, use this for player node
func get_stamina() -> int:
	return stamina

## attacks the player and saps their starvation meter and adds it to self
func attack_player() -> void:
	global.player.decrease_starve(10)
	stamina += 10
	current_job = fish_job.DROP
	can_attack_player = false
	player_attack_cooldown_timer.start()
	current_job = fish_job.RANDOM
	global.sound_master.play("small_chomp")

func reset_player_attack_cooldown() -> void:
	can_attack_player = true


## Gets the angle to the player from the baby_fish
func get_angle_to_player() -> float:
	return global_position.angle_to_point(global.player.player_position())
