extends Node2D
@onready var animation_player : AnimationPlayer = $animation_player

func _ready() -> void:
    animation_player.play("default")
    global.sound_master.play_lightning()
