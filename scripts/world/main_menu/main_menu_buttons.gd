extends Control
@onready var menu : Control = get_parent()
@onready var start_button   : TextureButton  = $MarginContainer/VBoxContainer/start_button
@onready var options_button : TextureButton  = $MarginContainer/VBoxContainer/options_button
@onready var controls_button : TextureButton = $MarginContainer/VBoxContainer/controls_button
@onready var quit_button : TextureButton     = $MarginContainer/VBoxContainer/quit_button

var hover_color : Color = Color(255,0,0,255) # Color when we hover a button
var reset_color : Color = Color(1,1,1,1)     # Color when we stop hovering, this can be forced to be default color
#region Button_Press
func _on_start_button_pressed() -> void:
	global.world_master.change_world(2)

func _on_options_button_pressed() -> void:
	menu.switch_menu(1)

func _on_controls_button_pressed() -> void:
	global.world_master.change_world(1)

func _on_quit_button_pressed() -> void:
	get_tree().quit()
#endregion


#region Hovering a button Code
func _on_start_button_mouse_entered() -> void:
	start_button.set_deferred("modulate", hover_color)
	global.sound_master.play("button_hover")


func _on_start_button_mouse_exited() -> void:
	start_button.set_deferred("modulate", reset_color)

func _on_options_button_mouse_entered() -> void:
	options_button.set_deferred("modulate", hover_color)
	global.sound_master.play("button_hover")

func _on_options_button_mouse_exited() -> void:
	options_button.set_deferred("modulate", reset_color)

func _on_controls_button_mouse_entered() -> void:
	controls_button.set_deferred("modulate", hover_color)
	global.sound_master.play("button_hover")

func _on_controls_button_mouse_exited() -> void:
	controls_button.set_deferred("modulate", reset_color)

func _on_quit_button_mouse_entered() -> void:
	quit_button.set_deferred("modulate", hover_color)
	global.sound_master.play("button_hover")

func _on_quit_button_mouse_exited() -> void:
	quit_button.set_deferred("modulate", reset_color)
#endregion
