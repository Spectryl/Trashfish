extends Control
@onready var menu : Control = get_parent()
@onready var title_screen_button  : TextureButton = $title_screen_button
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.




func _on_title_screen_button_pressed() -> void:
	menu.switch_menu(0)


func _on_title_screen_button_mouse_entered() -> void:
	title_screen_button.set_deferred("modulate", Color8(0,255,255,255))
	global.sound_master.play("button_hover")
func _on_title_screen_button_mouse_exited() -> void:
	title_screen_button.set_deferred("modulate", Color8(255,255,255,255))
