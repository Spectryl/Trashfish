extends Control
@onready var resume_button  : TextureButton = $MarginContainer/VBoxContainer/resume_button
@onready var options_button : TextureButton = $MarginContainer/VBoxContainer/options_button
@onready var quit_button    : TextureButton = $MarginContainer/VBoxContainer/quit_button

func _ready() -> void:
	self.visible = false

func _on_resume_button_pressed() -> void:
	self.visible = false
	get_tree().paused = false


func _on_options_button_pressed() -> void:
	match global.world_master.get_world_id():
		0:
			pass
		1:
			pass


func _on_quit_button_pressed() -> void:
	global.world_master.change_world(0)
