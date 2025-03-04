extends Node2D

@export var max_speed : int

@onready var sea_weed1 : AnimatedSprite2D = $sea_weed
@onready var sea_weed2 : AnimatedSprite2D = $sea_weed2
@onready var weed_player: AnimationPlayer = $AnimationPlayer
@onready var cpu_particles: CPUParticles2D= $CPUParticles2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sea_weed1.play("default")
	sea_weed2.play("default")
	weed_player.play("left_sea_weed")
	cpu_particles.speed_scale = randf_range(0.25,1)
	sea_weed1.modulate = Color8(randi_range(0,255), 255, randi_range(0,255), 255)
	sea_weed2.modulate = Color8(randi_range(0,255), 255, randi_range(0,255), 255)
	cpu_particles.modulate = Color8(randi_range(0,255),255,255,255)


	sea_weed1.material.set_shader_parameter("minStrength", randf_range(0,0.1))
	sea_weed2.material.set_shader_parameter("minStrength", randf_range(0,0.1))


	match randi_range(0,1):
		0:
			weed_player.play("left_sea_weed")
			sea_weed1.z_index = 1
		_:
			weed_player.play("right_sea_weed")
			sea_weed2.z_index = 1
	weed_player.set_speed_scale( randf_range(0.125, 8) )
	sea_weed1.sprite_frames.set_animation_speed("default",randi_range(2,6))
	sea_weed2.sprite_frames.set_animation_speed("default",randi_range(2,6))
