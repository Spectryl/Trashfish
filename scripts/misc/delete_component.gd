extends Node2D
@export var delete_time : float
var delete_timer : Timer
# Purpose of this component is to automatically delete things when they aren't needed anymore


func _ready() -> void:
	delete_timer = Timer.new()
	delete_timer.wait_time = delete_time
	delete_timer .one_shot = true
	self.add_child(delete_timer)
	delete_timer.timeout.connect(_on_delete_timer_timeout)
	delete_timer.start()


func _on_delete_timer_timeout() -> void:
	self.get_parent().queue_free()
