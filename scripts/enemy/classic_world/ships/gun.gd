extends AnimatedSprite2D
@onready var player = global.player
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func set_gun_rotation():
	self.set_global_rotation(get_angle_to_player())
	self.flip_v = 1 if self.global_rotation > 1.57 else 0

# Gets the angle to the player from the gun
func get_angle_to_player() -> float:
	return self.global_position.angle_to_point(player.player_position())
