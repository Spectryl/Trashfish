extends Control
@onready var death_text  : TextureRect    = $death_text
@onready var score       : Label          = $score
@onready var play_button : TextureButton  = $VBoxContainer/play_again_button
@onready var quit_button : TextureButton  = $VBoxContainer/quit_button

var score_str : String

var hover_color : Color = Color8(255,121, 86, 255)
var reset_color : Color = Color8(255,255,255,255)

func _ready() -> void:
	score.text = score_str

func _on_play_again_button_pressed() -> void:
	global.world_master.reset_world()

func _on_play_again_button_mouse_entered() -> void:
	play_button.set_deferred("modulate", hover_color)
	global.sound_master.play("button_hover")


func _on_play_again_button_mouse_exited() -> void:
	play_button.set_deferred("modulate", reset_color)

func _on_quit_button_pressed() -> void:
	global.world_master.change_world(0)


func _on_quit_button_mouse_entered() -> void:
	quit_button.set_deferred("modulate", hover_color)
	global.sound_master.play("button_hover")


func _on_quit_button_mouse_exited() -> void:
	quit_button.set_deferred("modulate", reset_color)
