extends Node2D
var animated_sprite : Node2D
var drop_component : Node2D
var particles : Node2D
var audio_player

func _ready() -> void:
	animated_sprite = get_node("AnimatedSprite2D")
	drop_component = get_node("drop_component")
	particles = get_node("CPUParticles2D")

	
	animated_sprite.play("idle")
	drop_component.timer_length += randi_range(0,4)
	drop_component.fall_speed += randi_range(0,55)

func timer_timeout_event():
	global.world.sound_master.play("explosion1")
	self.rotation_degrees = 0
	$explosion_hitbox/CollisionPolygon2D.set_deferred("disabled", false)
	animated_sprite.play("explosion")
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
	
