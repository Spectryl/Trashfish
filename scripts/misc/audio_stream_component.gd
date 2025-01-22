extends AudioStreamPlayer
@export var pitch_scale_min : float = 0.99
@export var pitch_scale_max : float = 1.01


func play_audio(from_position: float = 0.0) -> void:
	self.pitch_scale = randf_range(pitch_scale_min, pitch_scale_max)
	super.play(from_position)
