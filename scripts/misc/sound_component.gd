extends Node2D
@onready var audio : AudioStreamPlayer = $audio

func play_audio(path_to_sound_file : String) -> void:
	audio.stream = load(path_to_sound_file)
	audio.play()

func stop() -> void:
	audio.stop()

func _on_audio_finished() -> void:
	queue_free()
