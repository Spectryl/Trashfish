extends Node2D

@onready var sprite : Node2D            = get_node("AnimatedSprite2D")
@onready var drop_component : Node2D    = get_node("drop_component")
@onready var particles : CPUParticles2D = get_node("CPUParticles2D")
var collision : CollisionShape2D

var particle_check : bool = false
func _ready() -> void:
	sprite.play("idle")
	drop_component.timer_length += randi_range(0,15)
	drop_component.fall_speed += randi_range(0,210)
	collision = $StaticBody2D/CollisionShape2D
func timer_timeout_event():
	self.rotation_degrees = 0
	$explosion_hitbox/CollisionShape2D.set_deferred("disabled", false)
	sprite.play("explosion")
	collision.set_deferred("disabled", true)
	$CPUParticles2D.emitting = true

func _on_explosion_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.set_debuff("flipped_controls")
	if body.is_in_group("baby_fish"):
		body.call_deferred("queue_free")

# When the player attacks this object
func attacked():
	global.world.score += 1
	drop_component.delete_timer.start()
	drop_component.isActive = false #freezes the object
	$StaticBody2D.set_deferred("disable_mode",true) # disables the eating hitboxes
	collision.set_deferred("disabled",true)
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