extends CheckButton


func _ready() -> void:
	button_pressed = save_master.save_data.get_value("settings","vsync",true)
