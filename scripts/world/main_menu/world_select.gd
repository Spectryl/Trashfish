extends Control
@onready var menu        : Control              = get_parent()
@onready var back_button : TextureButton        = $back_button
@onready var worlds      : HBoxContainer        = $worlds
var beach                : TwoClickTextureButton
var volcano              : TwoClickTextureButton
var electro              : TwoClickTextureButton
var hover_color : Color = Color8(0,255,255,255) # Color when we hover a button
var reset_color : Color = Color8(255,255,255,255)     # Color when we stop hovering, this can be forced to be default color

func _ready() -> void:
	beach = TwoClickTextureButton.new()
	beach.texture_normal = load("res://resources/buttons/beach_world_icon.tres")
	beach.left_click .connect(_on_beach_left_click_pressed)
	beach.right_click.connect(_on_beach_right_click_pressed)
	worlds.add_child(beach)

	volcano = TwoClickTextureButton.new()
	volcano.texture_normal = load("res://resources/buttons/locked_world_icon.tres")
	electro = TwoClickTextureButton.new()
	electro.texture_normal = load("res://resources/buttons/locked_world_icon.tres")
	worlds.add_child(volcano)
	worlds.add_child(electro)
	

func _on_beach_left_click_pressed() -> void:
	global.world_master.change_world(2)
func _on_beach_right_click_pressed() -> void:
	print("right click")

func _on_back_button_pressed() -> void:
	menu.switch_menu(0)

func _on_back_button_mouse_entered() -> void:
	back_button.set_deferred("modulate", hover_color)
	global.sound_master.play("button_hover")


func _on_back_button_mouse_exited() -> void:
	back_button.set_deferred("modulate", reset_color)
