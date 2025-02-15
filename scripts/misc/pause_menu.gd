extends Control
@onready var resume_button  : TextureButton = $MarginContainer/VBoxContainer/resume_button
@onready var quit_button    : TextureButton = $MarginContainer/VBoxContainer/quit_button

var hover_color : Color = Color8(113,255,13,255)
var reset_color : Color = Color8(255,255,255,255)
var options_menu : Control
func _ready() -> void:
	self.visible = false
	self.global_position = Vector2(942,479)
	self.z_index = 99

func _on_resume_button_pressed() -> void:
	resume_game()
	get_tree().paused = false


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if global.world_master.get_world_id() == 0 or global.world_master.get_world_id() == 1:
			return
		self.visible = !visible
		get_tree().paused = !get_tree().paused

func _on_quit_button_pressed() -> void:
	resume_game()
	global.world_master.change_world(0)


func resume_game() -> void:
	self.visible = false
	get_tree().paused = false



func _on_resume_button_mouse_entered() -> void:
	resume_button.set_deferred("modulate", hover_color)
	global.sound_master.play("button_hover")


func _on_resume_button_mouse_exited() -> void:
	resume_button.set_deferred("modulate", reset_color)

func _on_quit_button_mouse_entered() -> void:
	quit_button.set_deferred("modulate", hover_color)
	global.sound_master.play("button_hover")


func _on_quit_button_mouse_exited() -> void:
	quit_button.set_deferred("modulate", reset_color)
