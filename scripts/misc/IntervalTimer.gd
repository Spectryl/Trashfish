class_name IntervalTimer
extends Timer


## Purpose is to create a timer that checks for things every so often, that way we don't need to check things on every frame
func _init(function_to_call : Callable, time: float = 3.0 ) -> void:
	wait_time = time
	timeout.connect(function_to_call)
	one_shot = true
	autostart = false
