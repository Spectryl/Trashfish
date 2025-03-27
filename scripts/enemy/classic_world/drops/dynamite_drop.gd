extends Node2D
@onready var sprite : Node2D            = get_node("AnimatedSprite2D")
@onready var drop_component : Node2D    = get_node("drop_component")
@onready var particles : CPUParticles2D = get_node("CPUParticles2D")
var sound_timer : Timer

var stream_length : float

var particle_check : bool = false
func _ready() -> void:
	sprite.play("idle")
	drop_component.timer_length += randi_range(0,4)
	drop_component.fall_speed += randi_range(0,55)
	
	
	sound_timer = Timer.new()
	stream_length = global.sound_master.fuse.stream.get_length()
	sound_timer.wait_time = stream_length
	sound_timer.one_shot  = true
	sound_timer.autostart = false
	add_child(sound_timer)
	sound_timer.timeout.connect(sound_timer_timeout_event)
	sound_timer.start(stream_length)
	global.sound_master.play("fuse")
	
	sprite.position = Vector2(9,-13)

func sound_timer_timeout_event():
	global.sound_master.play("fuse")
	sound_timer.start()
	

func timer_timeout_event():
	sound_timer.stop()
	global.sound_master.play("explosion1")
	rotation_degrees = 0
	$explosion_hitbox/CollisionPolygon2D.set_deferred("disabled", false)
	sprite.play("explosion")
	sprite.position = Vector2(0,0)
	$StaticBody2D/CollisionPolygon2D.set_deferred("disabled", true)
	particles.emitting = true


func _on_explosion_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.decrease_health()
	if body.is_in_group("baby_fish"):
		body.call_deferred("queue_free")
	if body.is_in_group("orca"):
		body.attacked(self)
# When the player attacks this object
func attacked():
	global.world.score += 1
	drop_component.delete_timer.start()
	drop_component.isActive = false
	drop_component.active_timer.stop()
	drop_component.active_timer.emit_signal("timeout")
	
func baby_fish_attack_event(fish_weight : int) -> void:
	var time_left : float = drop_component.active_timer.time_left

	drop_component.active_timer.stop()
	var new_time : float = time_left * (1.0 - clamp(fish_weight / 50.0, 0.3, 0.9))
	drop_component.active_timer.start(new_time)
	# IF the time is so low that the drop just instantly deletes it self, then just show a particle so its conveyed to the player that the baby fish attacked the drop
	if new_time < 0.5:
		particle_check = true
	#	fish_weight / 50
	#time_left     0.25
	#1.0         ->0.00
