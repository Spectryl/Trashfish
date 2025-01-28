extends Node2D
var animated_sprite : Node2D
var drop_component : Node2D
var particles : Node2D
var sound_timer : Timer

var stream_length : float
func _ready() -> void:
	animated_sprite = get_node("AnimatedSprite2D")
	drop_component = get_node("drop_component")
	particles = get_node("CPUParticles2D")
	animated_sprite.play("idle")
	drop_component.timer_length += randi_range(0,4)
	drop_component.fall_speed += randi_range(0,55)
	
	
	sound_timer = Timer.new()
	stream_length = global.sound_master.fuse.stream.get_length()
	sound_timer.wait_time = stream_length
	sound_timer.one_shot  = false
	sound_timer.autostart = false
	add_child(sound_timer)
	sound_timer.timeout.connect(sound_timer_timeout_event)
	sound_timer.start(stream_length)
	global.sound_master.play("fuse")
	
	animated_sprite.position = Vector2(9,-13)

func sound_timer_timeout_event():
	global.sound_master.play("fuse")
	

func timer_timeout_event():
	sound_timer.stop()
	global.sound_master.play("explosion1")
	rotation_degrees = 0
	$explosion_hitbox/CollisionPolygon2D.set_deferred("disabled", false)
	animated_sprite.play("explosion")
	animated_sprite.position = Vector2(2,-4)
	$StaticBody2D/CollisionPolygon2D.set_deferred("disabled", true)
	particles.emitting = true


func _on_explosion_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.decrease_health()

# When the player attacks this object
func attacked():
	global.world.score += 1
	drop_component.delete_timer.start()
	drop_component.isActive = false
	drop_component.active_timer.stop()
	drop_component.active_timer.emit_signal("timeout")
	
