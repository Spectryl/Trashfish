extends Node2D
@onready var drop_component : Node2D = $drop_component

func _ready() -> void:
	drop_component.timer_length += randi_range(0,6)
	drop_component.fall_speed += randi_range(0,30)

## This Exists for every node, this needs to be here or problems start
func timer_timeout_event() -> void:
	pass

func attacked() -> void:
	global.world.score += 1
	particle_event()
	
func particle_event() -> void:
	$CPUParticles2D.emitting = true
	$StaticBody2D/CollisionShape2D.set_deferred("disabled",true)
	$Sprite2D.visible = false
	drop_component.isActive = false
	drop_component.particle_timer.start()

func baby_fish_attack_event(fish_weight : int) -> void:
	drop_component.fall_speed += (fish_weight)