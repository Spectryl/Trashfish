extends CharacterBody2D
@onready var body : Sprite2D                           = $CanvasGroup/body
@onready var fins : AnimatedSprite2D                   = $CanvasGroup/fins
@onready var bin  : Sprite2D                           = $CanvasGroup/bin
@onready var tail : AnimatedSprite2D                   = $CanvasGroup/tail
@onready var animation_player : AnimationPlayer        = $AnimationPlayer
@onready var collision : CollisionShape2D              = $CollisionShape2D
@onready var particle : CPUParticles2D                 = $CPUParticles2D
@onready var navigation_agent : NavigationAgent2D      = $NavigationAgent2D
@onready var attack_hitbox : CollisionShape2D          = $Area2D/CollisionShape2D
@onready var attack_cooldown_timer : Timer             = $attack_cooldown_timer
@onready var parent : Node2D = get_parent()

@export var health : int = 3
@export var speed  : int = 150
const acceleration = 10
var endPos : Vector2
var angle : float
var direction : Vector2
var distance : Vector2
var current_state : state


var angle_of_object_that_is_attacking_me : float
enum state {
	SWIM = 0,
	ATTACK = 1,
	HURT = 2
}

func _ready() -> void:
	animation_player.play("RESET")
	current_state = state.SWIM
	bin.visible = true
	var parentX : int = int(parent.global_position.x)
	var parentY : int = int(parent.global_position.y)
	speed += randi_range(0,50)
	match parentX < 100:
		true:
			endPos.x = 2000
			endPos.y = randi_range(0,700) + 250
			global_position.x = -100
			global_position.y = parentY
			
		_:
			endPos.x = -100
			endPos.y = randi_range(0,700) + 250
			global_position.x = 2000
			global_position.y = parentY
	create_new_angle()


## turns on the particles when the orca goes anger mode, run this in the animation player
func turn_on_particles() -> void:
	particle.emitting = true

func attacked(object: Node2D) -> void:
	if current_state == state.HURT:
		return
	velocity = Vector2(0,0)
	print("Orca has been hit!")
	change_state(2)
	animation_player.play("attacked")
	angle_of_object_that_is_attacking_me = global_position.angle_to_point(object.global_position) + PI
	attack_hitbox.set_deferred("disabled", true)
	#animation_player.play("start_anger_mode")

func _physics_process(delta) -> void:
	work(delta)
	if global_position.x > 2000 or global_position.x < -100:
		parent.fish_returned += 1
		call_deferred("queue_free")
	move_and_slide()

## do an assignment based on our current state
func work(delta):
	match current_state:
		state.SWIM:
			velocity.x = lerp(velocity.x, speed * direction.x, acceleration * delta)
			velocity.y = lerp(velocity.y, speed * direction.y * 0.45, acceleration * delta)
			animation_player.play("swim_right" if velocity.x > 0 else "swim_left")
		state.HURT:
			var obj_direction = Vector2(cos(angle_of_object_that_is_attacking_me), sin(angle_of_object_that_is_attacking_me))
			velocity.x = lerp(velocity.x, speed * obj_direction.x / 2, acceleration * delta)
			velocity.y = lerp(velocity.y, speed * obj_direction.y * 0.45 / 2, acceleration * delta)
		state.ATTACK:
			navigation_agent.target_position = global.player.global_position
			var nav_direction : Vector2 = (navigation_agent.get_next_path_position() - global_position).normalized()
			velocity.x = lerp(velocity.x, speed * nav_direction.x, acceleration * delta)
			velocity.y = lerp(velocity.y, speed * nav_direction.y * 0.45, acceleration * delta)
			animation_player.play("swim_right" if velocity.x > 0 else "swim_left")
## allows the animation player to change the state we are on
func change_state(new_state : int):
	#print(new_state)
	@warning_ignore("int_as_enum_without_cast")
	current_state = new_state

## change the angle we are heading towards
func create_new_angle() -> void:
	angle = global_position.angle_to_point(endPos)
	direction = Vector2.from_angle(angle)
	distance = direction * speed

func decrease_health() -> void:
	health -= 1

	if health == 1:
		animation_player.play("start_anger_mode")
		speed *= 2
		return
	if health == 0:
		global.world.score += 1
		call_deferred("queue_free")
	change_state(0)
	attack_hitbox.set_deferred("disabled", false)
func _on_area_2d_body_entered(object: Node2D) -> void:
	if object == self:
		return

	if object.is_in_group("player"):
		global.sound_master.play_chomp()
		object.decrease_health()
	if object.is_in_group("drop"):
		global.sound_master.play_chomp()
		object.get_parent().queue_free()
	if object.is_in_group("baby_fish"):
		global.sound_master.play_chomp()
		object.attacked()
		return
	if object.is_in_group("orca"):
		global.sound_master.play_chomp()
		object.attacked(self)
		return

func reset_attack_cooldown_timer() -> void:
	attack_hitbox.set_deferred("disabled", false)
