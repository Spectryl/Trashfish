extends Node2D
@onready var sprite : Node2D            = get_node("Sprite2D")
@onready var drop_component : Node2D    = get_node("drop_component")
@onready var particles : CPUParticles2D = get_node("CPUParticles2D")

var particle_check : bool = false
func _ready() -> void:
	drop_component.timer_length += randi_range(0,10)
	drop_component.fall_speed += randi_range(0,200)

func timer_timeout_event():
	pass


# When the player attacks this object
func attacked():
	global.world.score += 1
	global.world.heal_player()
	global.player.update_starve(100)
	particle_event()

#Basically this is an extra event between the activeness and deleteness so particles can properly appear for certain objects
func particle_event():
	particles.emitting = true
	$StaticBody2D/CollisionShape2D.set_deferred("disabled",true)
	sprite.visible = false
	drop_component.isActive = false
	drop_component.particle_timer.start()

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
