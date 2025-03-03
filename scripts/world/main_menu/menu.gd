extends Control

var menu : Control

func _ready() -> void:
	menu = load("res://scenes/world/main_menu/main_menu_buttons.tscn").instantiate()
	add_child(menu)
	
# Deletes the old menu and creates a new menu
func switch_menu(new_menu : int) -> void:
	menu.queue_free()
	match new_menu:
		0:
			menu = load("res://scenes/world/main_menu/main_menu_buttons.tscn").instantiate()
		1:
			menu = load("res://scenes/world/options_menu/options_ui.tscn").instantiate()
		2:
			menu = load("res://scenes/world/main_menu/world_select.tscn").instantiate()
		3:
			menu = load("res://scenes/world/main_menu/leader_board.tscn").instantiate()
	call_deferred("add_child", menu)
