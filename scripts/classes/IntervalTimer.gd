class_name IntervalTimer
extends Timer


## Purpose is to create a timer that checks for things every so often, that way we don't need to check things on every frame
func _init(function_to_call : Callable, time: float = 3.0, n_one_shot : bool = true, m_autostart : bool = false ) -> void:
	wait_time = time
	timeout.connect(function_to_call)
	one_shot = n_one_shot
	autostart = m_autostart 
