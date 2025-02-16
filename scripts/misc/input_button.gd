extends Button
@export var default_text : String
@export var action : String

var state : int = 0


func _input(event: InputEvent) -> void:
	if state != 1:
		return
	
	if event.pressed:
		InputMap.action_erase_events(action)
		InputMap.action_add_event(action, event)
		state = 0
		text = "%s" % InputMap.action_get_events(action)[0].as_text()
	



func _on_pressed() -> void:
	state += 1

	match state:
		1:
			text = "Press Key to remap!"
			release_focus()
