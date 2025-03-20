extends CharacterBody2D
@onready var body : Sprite2D                    = $CanvasGroup/body
@onready var fins : AnimatedSprite2D            = $CanvasGroup/fins
@onready var bin  : Sprite2D                    = $CanvasGroup/bin
@onready var tail : AnimatedSprite2D            = $CanvasGroup/tail
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var collision : CollisionShape2D       = $CollisionShape2D
@onready var particle : CPUParticles2D          = $CPUParticles2D
@onready var nav_agent : NavigationAgent2D      = $NavigationAgent2D
@onready var parent : Node2D = get_parent()

@export var health : int = 3
@export var speed  : int = 150
const acceleration = 10
var endPos : Vector2
var angle : float
var direction : Vector2
var distance : Vector2
var current_state : state
enum state {
	SWIM = 0,
	ATTACK = 1,
	HURT = 2
}

func _ready() -> void:
	current_state = state.SWIM
	bin.visible = true
	var parentX : int = int(parent.global_position.x)
	var parentY : int = int(parent.global_position.y)
	speed += randi_range(0,50)
	match parentX:
		50:
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

func attacked() -> void:
	if current_state == state.HURT:
		return
	velocity = Vector2(0,0)
	print("Orca has been hit!")
	animation_player.play("attacked")
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
			animation_player.play("swim_right" if velocity.x > 0 else "swim_left")
			velocity.x = lerp(velocity.x, speed * direction.x, acceleration * delta)
			velocity.y = lerp(velocity.y, speed * direction.y * 0.45, acceleration * delta)
		state.HURT:
			print("ouch")
		state.ATTACK:
			print("time to hurt!")
## allows the animation player to change the state we are on
func change_state(new_state : state):
	print(new_state)
	current_state = new_state

## change the angle we are heading towards
func create_new_angle() -> void:
	angle = global_position.angle_to_point(endPos)
	direction = Vector2.from_angle(angle)
	distance = direction * speed

func decrease_health() -> void:
	health -= 1

	if health == 1:
		change_state(state.ATTACK)
		return
	change_state(state.SWIM)
