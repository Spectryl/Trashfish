extends CharacterBody2D
@onready var body : Sprite2D                    = $body
@onready var fins : AnimatedSprite2D            = $fins
@onready var bin  : Sprite2D                    = $bin
@onready var tail : Sprite2D                    = $tail
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var collision : CollisionShape2D       = $CollisionShape2D
@onready var particle : CPUParticles2D          = $CPUParticles2D

func _ready():
	bin.visible = true

## turns on the particles when the orca goes anger mode, run this in the animation player
func turn_on_particles():
	particle.emitting = true
