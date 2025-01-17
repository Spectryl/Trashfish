extends Node2D
@onready var drop_component = $drop_component

func _ready() -> void:
	drop_component.timer_length += randi_range(0,10)
	drop_component.fall_speed += randi_range(0,200)

func timer_timeout_event():
	pass


# When the player attacks this object
func attacked():
	#     Ship       Ship master   world
	global.world.score += 1
	global.world.heal_player()
	particle_event()

#Basically this is an extra event between the activeness and deleteness so particles can properly appear for certain objects
func particle_event():
	$CPUParticles2D.emitting = true
	$StaticBody2D/CollisionShape2D.set_deferred("disabled",true)
	$Sprite2D.visible = false
	drop_component.isActive = false
	drop_component.particle_timer.start()
