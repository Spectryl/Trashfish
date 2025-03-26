class_name RebindButton
extends Control

@onready var label  : Label  = $HBoxContainer/Label
@onready var button : Button = $HBoxContainer/Button

@export var action_name : String

func _ready() -> void:
	set_process_unhandled_key_input(false)
	set_action_name()
	set_text_for_key()

func set_action_name() -> void:
	label.text = "unassigned"
	match action_name:
		"move_left":
			label.text = "Move Left"
		"move_up":
			label.text = "Move Up"
		"move_down":
			label.text = "Move Down"
		"move_right":
			label.text = "Move Right"
		"attack":
			label.text = "Attack"
		"roll":
			label.text = "Roll"

func set_text_for_key() -> void:
	var action_events = InputMap.action_get_events(action_name)
	var action_event = action_events[0]
	var action_keycode = OS.get_keycode_string(action_event.physical_keycode)
	button.text = "%s" % action_keycode

func _on_button_toggled(toggled_on:bool) -> void:
	if toggled_on:
		button.text = "Press a key"
		set_process_unhandled_key_input(toggled_on)

		for i in get_tree().get_nodes_in_group("controls"):
			if i.action_name != self.action_name:
				i.button.toggle_mode = false
				i.set_process_unhandled_key_input(false)

	else:
		for i in get_tree().get_nodes_in_group("controls"):
			if i.action_name != self.action_name:
				i.button.toggle_mode = true
				i.set_process_unhandled_key_input(false)
		set_text_for_key()


func _unhandled_key_input(event: InputEvent) -> void:
	rebind_action_key(event)
	button.button_pressed = false


func rebind_action_key(event) -> void:
	var is_duplicate=false
	var action_event=event
	var action_keycode=OS.get_keycode_string(action_event.physical_keycode)
	for i in get_tree().get_nodes_in_group("controls"):
			if i.action_name!=self.action_name:
				if i.button.text=="%s" %action_keycode:
					is_duplicate=true
					break
	if not is_duplicate:
		InputMap.action_erase_events(action_name)
		InputMap.action_add_event(action_name,event)
		save_master.controls.set_value("controls" , action_name as String, int(action_event.physical_keycode) as int)
		save_master.controls.save_encrypted_pass("user://controls.cfg", save_master.password)
		print(save_master.controls.get_value("controls", action_name))
		set_process_unhandled_key_input(false)
		set_text_for_key()
		set_action_name()

func initial_update_key_text() -> void:
	var action_events = InputMap.action_get_events(action_name)
	var action_event = action_events[0]
	var action_keycode = OS.get_keycode_string(action_event.get_keycode())
	button.text = "%s" % action_keycode

func set_mouse_cursor(i : int) -> void:
	Cursor.set_shape(i)
