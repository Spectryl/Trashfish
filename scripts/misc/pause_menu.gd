extends Control
@onready var canvas_layer : CanvasLayer     = $canvas_layer
@onready var resume_button  : TextureButton = $canvas_layer/MarginContainer/VBoxContainer/resume_button
@onready var quit_button    : TextureButton = $canvas_layer/MarginContainer/VBoxContainer/quit_button

var hover_color : Color = Color8(113,255,13,255)
var reset_color : Color = Color8(255,255,255,255)
var options_menu : Control
func _ready() -> void:
	canvas_layer.visible = false
	self.global_position = Vector2(942,479)
	canvas_layer.layer = 5

func _on_resume_button_pressed() -> void:
	resume_game()
	get_tree().paused = false


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if global.world_master.get_world_id() == 0 or global.world_master.get_world_id() == 1:
			return
		canvas_layer.visible = !canvas_layer.visible
		get_tree().paused = !get_tree().paused

func _on_quit_button_pressed() -> void:
	resume_game()
	global.world_master.change_world(0)


func resume_game() -> void:
	canvas_layer.visible = false
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
