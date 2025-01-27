extends Node2D
@onready var drop_component = $drop_component

func _ready() -> void:
	drop_component.timer_length += randi() % 6
	drop_component.fall_speed += randi() % 30 

func timer_timeout_event():
	pass

func attacked():
	global.world.score += 1
	particle_event()
	
func particle_event():
	$CPUParticles2D.emitting = true
	$StaticBody2D/CollisionShape2D.set_deferred("disabled",true)
	$Sprite2D.visible = false
	drop_component.isActive = false
	drop_component.particle_timer.start()
