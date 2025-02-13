extends Control

const main_menu_buttons = preload("res://scenes/world/main_menu/main_menu_buttons.tscn")
const options_menu      = preload("res://scenes/world/options_menu/options_ui.tscn")
const world_select      = preload("res://scenes/world/main_menu/world_select.tscn")
var menu : Control

func _ready() -> void:
	menu = main_menu_buttons.instantiate()
	add_child(menu)
	
# Deletes the old menu and creates a new menu
func switch_menu(new_menu : int) -> void:
	menu.queue_free()
	match new_menu:
		0:
			menu = main_menu_buttons.instantiate()
		1:
			menu = options_menu.instantiate()
		2:
			menu = world_select.instantiate()
	call_deferred("add_child", menu)
