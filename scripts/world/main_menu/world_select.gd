extends Control
@onready var menu        : Control              = get_parent()
@onready var back_button : TextureButton        = $back_button
@onready var worlds      : HBoxContainer        = $worlds
var beach                : WorldSelect
var state : int = 0
var hover_color : Color = Color8(0,255,255,255) # Color when we hover a button
var reset_color : Color = Color8(255,255,255,255)     # Color when we stop hovering, this can be forced to be default color
var bounce_shine_shader : String = "res://resources/buttons/world_icon.res"
func _ready() -> void:
	beach = WorldSelect.new()
	beach.world_icon_button = TwoClickTextureButton.new()
	beach.texture_rect = TextureRect.new()
	beach.left_button  = TextureButton.new()
	beach.right_button = TextureButton.new()
	beach.add_theme_constant_override("separation", -8)
	
	beach.world_icon_button.left_click.connect(beach_left_click)
	beach.world_icon_button.call_deferred("connect","right_click", beach_right_click)
	beach.left_button.call_deferred("connect","pressed" , beach_minus_signal )
	beach.right_button.call_deferred("connect","pressed" , beach_right_click )
	beach.max_gamemodes = 1
	beach.first_texture  = load("res://resources/buttons/beach_world_icon.tres")
	beach.second_texture = load("res://resources/buttons/beach_world_guns_icon.tres")
	
	beach.world_icon_button.texture_normal = load("res://resources/buttons/beach_world_icon.tres")
	beach.world_icon_button.material = load(bounce_shine_shader)
	beach.world_icon_button.material.set_shader_parameter("do_abs", false)
	beach.world_icon_button.material.set_shader_parameter("do_quantize", true)
	beach.world_icon_button.material.set_shader_parameter("sine_amplitude", Vector2(0,10))
	beach.world_icon_button.material.set_shader_parameter("sine_speed", Vector2(0,4))
	beach.world_icon_button.material.set_shader_parameter("time_offset", 55.0)
	beach.texture_rect.texture = load("res://resources/buttons/gamemode_selection_background.res")
	
	beach.texture_rect.material = load("res://resources/buttons/gamemode_icon_bounce.res")
	beach.create_sign_buttons()

	
	beach.add_children()
	
	worlds.add_child(beach)

func beach_left_click() -> void:
	match beach.state:
		0:
			global.world_master.change_world(2)
		1: 
			global.world_master.change_world(3)

func beach_right_click() -> void:
	beach.state += 1
	change_beach_state()

func beach_minus_signal() -> void:
	beach.state -= 1
	change_beach_state()
	
	

func change_beach_state() -> void:
	if beach.state > beach.max_gamemodes: #reset the counter to zero
		beach.state = 0
	if beach.state < 0:
		beach.state = beach.max_gamemodes
	# Match the visualness of a button based on our state
	match beach.state:
		0:
			beach.world_icon_button.texture_normal = beach.first_texture
		1:
			beach.world_icon_button.texture_normal = beach.second_texture

func _on_back_button_pressed() -> void:
	menu.switch_menu(0)

func _on_back_button_mouse_entered() -> void:
	back_button.set_deferred("modulate", hover_color)
	global.sound_master.play("button_hover")


func _on_back_button_mouse_exited() -> void:
	back_button.set_deferred("modulate", reset_color)
