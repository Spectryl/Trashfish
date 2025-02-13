extends Control
@onready var menu        : Control       = get_parent()
@onready var back_button : TextureButton = $back_button

var hover_color : Color = Color8(0,255,255,255) # Color when we hover a button
var reset_color : Color = Color8(255,255,255,255)     # Color when we stop hovering, this can be forced to be default color

func _on_beach_pressed() -> void:
	global.world_master.change_world(2)


func _on_back_button_pressed() -> void:
	menu.switch_menu(0)

func _on_back_button_mouse_entered() -> void:
	back_button.set_deferred("modulate", hover_color)
	global.sound_master.play("button_hover")


func _on_back_button_mouse_exited() -> void:
	back_button.set_deferred("modulate", reset_color)