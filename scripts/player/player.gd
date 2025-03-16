extends CharacterBody2D
var speed : float = 250
const acceleration : float = 22
var starve : int = 100
@export var health : int = 6
@export var max_starve : int = 100
@export var max_health : int = 10
@export var world_id : int = 0
@export var honey_speed : float = 2.5
@export var ice_speed : int = 5

@onready var honey_sprite : AnimatedSprite2D      = $CanvasGroup/honey
@onready var ice_sprite : AnimatedSprite2D        = $CanvasGroup/ice
@onready var canvas_group : CanvasGroup           = $CanvasGroup
@onready var head : AnimatedSprite2D              = $CanvasGroup/head
@onready var body : AnimatedSprite2D              = $CanvasGroup/body
@onready var attack_hitbox : CollisionShape2D     = $attack_hitbox/CollisionShape2D
@onready var attack_timer : Timer                 = $attack_hitbox/attack_timer
@onready var flash_timer : Timer                  = $CanvasGroup/body/flash_timer
@onready var honey_timer : Timer                  = $debuff_master/honey_timer
@onready var ice_timer : Timer                    = $debuff_master/ice_timer
@onready var control_timer : Timer                = $debuff_master/control_timer
@onready var roll_timer : Timer                   = $debuff_master/roll_timer
@onready var roll_cooldown_timer : Timer          = $debuff_master/roll_cooldown_timer
@onready var starve_timer : Timer                 = $Starve_Timer

@onready var body_hurtbox : CollisionPolygon2D    = $CollisionPolygon2D

var is_attacking : bool        = false
var is_dead : bool             = false
var is_honeyd : bool           = false
var is_iced : bool             = false
var is_rolling : bool          = false
var is_controls_flipped : bool = false
var is_active                  = false
var drop : Node
var direction : Vector2
const trash_can : PackedScene = preload("res://scenes/player/trash_can.tscn")
var world : Node2D
func _ready() -> void:
	honey_sprite.play("default")
	ice_sprite.play("default")
	player_flash_shader(0,0,0,0,0)

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("attack") and not is_attacking and not is_rolling:
		attack()
	if Input.is_action_just_pressed("roll") and not is_rolling and roll_cooldown_timer.is_stopped():
		roll()

func _physics_process(delta):
	if is_dead:
		return
	if health == 0:
		player_death()
		return
	handle_player_input(delta)
	handle_player_animation()
	move_and_slide()
## Handles basic player movement
func handle_player_input(delta):
	if not is_rolling:
		direction = Input.get_vector("move_left","move_right","move_up","move_down").normalized()
	direction.x *= -1 if is_controls_flipped else 1
	direction.y *= -1 if is_controls_flipped else 1
	
	velocity.x = lerp(velocity.x, speed * direction.x, acceleration * delta)
	velocity.y = lerp(velocity.y, speed * direction.y * 0.65, acceleration * delta)
	rotation_degrees = 5 if not (abs(self.velocity.y) <= 10) else 0
	rotation_degrees *= -1 if self.velocity.x < 0 else 1
	rotation_degrees *= -1 if self.velocity.y < 0 else 1

## Handles basic player animations using bools/state machine
func handle_player_animation():
	if abs(velocity.x) > 0.001:
		flip(velocity.x < 0)
	if is_dead:
		body.play("death")
		return
	honey_sprite.visible = is_honeyd
	ice_sprite.visible = is_iced
	if is_attacking:
		head.play("attack")
	else:
		head.play("idle")
	match is_rolling:
		true:
			body.play("roll")
			return
		false:
			body.play("idle")
	body.play("idle")
	
##Flip the animations and hitboxes
func flip(value: bool):
	if value != body.flip_h:
		body.flip_h = value
		head.flip_h = value
		attack_hitbox.position.x *= -1
		honey_sprite.flip_h = value
		ice_sprite.flip_h = value
		body_hurtbox.rotation_degrees = -90 if body.flip_h else 90
		
## Handles the Player rolling logic
func roll():
	starve -= int(self.max_starve / 1.65)
	if starve <= 0:
		decrease_health()
		reset_starvation()
	is_rolling = true
	speed *= 1.8
	velocity = speed * direction
	
	head.visible = false
	roll_timer.start()

## Getter for health
func get_health():
	return health

## Variables to mess with player health
func set_health(change : int):
	health = change
	
func player_position() -> Vector2:
	return global_position

func decrease_health() :
	if world_id == 0 or world_id == 1 or (is_rolling and not starve <= 0):
		return
	health -= 1
	damage_flash_body()
## stamina-change should be a negative number
func decrease_starve(starve_change: int):
	if world_id == 0 or world_id == 1 or (is_rolling and not starve <= 0):
		return
	starve -= starve_change
	player_flash_shader(1, 1, 0, 1.0, 0.353)
	flash_timer.start()

func increase_health():
	health += 1
	if health > max_health:
		health = max_health
	heal_flash_body()
	
func player_death():
	global.world.update_hud_when_dead()
	health = 0
	is_dead = true
	body.play("death")
	head.visible = false
	drop = trash_can.instantiate()
	add_child(drop)
	
## If we attack, then we should turn on attack hitboxes
func attack():
	attack_hitbox.set_deferred("disabled", false)
	is_attacking = true
	attack_timer.start()
	
	
## Sets the player's debuff 
func set_debuff(debuff : String) -> void:
	match debuff:
		"honey":
			if is_honeyd:
				honey_timer.start()
				return
			is_honeyd = true
			speed /= honey_speed
			honey_timer.start()
		"ice":
			if is_iced:
				ice_timer.start()
				return
			is_iced = true
			speed /= ice_speed
			ice_timer.start()
		"flipped_controls":
			if is_controls_flipped:
				control_timer.start()
				return
				
			body.material.set_shader_parameter("u_tolerance", 0.055)
			head.material.set_shader_parameter("u_tolerance", 0.055)
			is_controls_flipped = true
			control_timer.start()

## Flashes the player body when damaged
func damage_flash_body():
	if health <= 0:
		return
	player_flash_shader(0.76,0,0,1.0, 0.7)
	flash_timer.start()
## flashes player body green when healed
func heal_flash_body():
	if health <= 0 or health > max_health:
		return
	player_flash_shader(0.13,0.86,0.14,1.0, 0.7)
	flash_timer.start()

## When the attack timer resets (CD), we should turn off hitboxes
func _on_attack_timer_timeout() -> void:
	get_node("attack_hitbox/CollisionShape2D").set_deferred("disabled", true)
	is_attacking = false

## handles what the attack hitbox calls on whatever it is attacking
func _on_attack_hitbox_body_entered(object: Node2D) -> void:
	#print(object)
	if object.is_in_group("player"):
		return
	if object.is_in_group("drop"):
		global.sound_master.play_chomp()
		update_starvation(int(max_starve / 3.0))
		object.get_parent().attacked()
		return
	if object.is_in_group("main_menu_block"):
		object.get_parent().attacked()
		return
	if object.is_in_group("baby_fish"):
		global.sound_master.play_chomp()
		update_starvation(object.get_stamina())
		object.attacked()
		return
		


func _on_honey_timer_timeout() -> void:
	speed = speed * honey_speed
	is_honeyd = false


func _on_ice_timer_timeout() -> void:
	speed = speed * ice_speed
	is_iced = false
	
func _on_control_timer_timeout():
	body.material.set_shader_parameter("u_tolerance", 0)
	head.material.set_shader_parameter("u_tolerance", 0)
	is_controls_flipped = false

func _on_flash_timer_timeout() -> void:
	canvas_group.material.set_shader_parameter("flash_modifier", 0)
	canvas_group.material.set_shader_parameter("flash_modifier", 0)
	
func _on_roll_timer_timeout():
	head.visible = true
	speed /= 1.8
	is_rolling = false
	roll_cooldown_timer.start()

# lets player know they can roll again
func _on_roll_cooldown_timer_timeout():
	global.sound_master.play("bloop")
	player_flash_shader(0.66, 0.51, 0.17, 1.0, 0.7)
	flash_timer.start(0.5)

#flashes the whole player sprite as a color
## A,B,C are RGB values from 0.0 -> 1.0, D is transparency and e is intensity
func player_flash_shader(a : float, b : float, c : float, d : float, e : float):
	canvas_group.material.set_shader_parameter("flash_color",Color(a,b,c,d))
	canvas_group.material.set_shader_parameter("flash_modifier", e)
	canvas_group.material.set_shader_parameter("flash_color",Color(a,b,c,d))
	canvas_group.material.set_shader_parameter("flash_modifier", e)
## every second we will take a bit of starvation
## default is you take a hit every 20 seconds of not eating
func _on_starve_timer_timeout():
	starve -= 5
	if starve <= 0:
		decrease_health()
		reset_starvation()

## Resets starvation back to export variable max_starve
func reset_starvation():
	starve = max_starve

## Adds/Subtracts the param to the current starve 
func update_starvation(new_starve : int = 30):
	starve += new_starve
	if starve > max_starve:
		starve = max_starve
