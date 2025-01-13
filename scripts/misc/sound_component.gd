extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func audio(path_to_sound_file : String) -> void:
	$audio.stream = load(path_to_sound_file)
	$audio.play()

func _on_audio_finished() -> void:
	self.queue_free()
