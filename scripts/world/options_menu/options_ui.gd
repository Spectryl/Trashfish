extends Control
@onready var menu : Control = get_parent()


func _on_texture_button_pressed() -> void:
	menu.switch_menu(0)
