extends Control
@onready var menu : Control = get_parent()


func _on_classic_pressed() -> void:
	global.world_master.change_world(2)
