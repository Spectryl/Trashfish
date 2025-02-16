extends VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in get_child_count():
		if get_child(i).is_in_group("controls"):
			get_child(i).initial_update_key_text()
