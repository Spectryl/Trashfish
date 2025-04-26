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
	beach.create_children()
	beach.max_gamemodes = 2
	## Connect signals and setup all textures
	beach.world_icon_button.left_click.connect(beach_left_click)
	beach.world_icon_button.call_deferred("connect","right_click", beach_right_click)
	beach.left_button.call_deferred("connect","pressed" , beach_minus_signal )
	beach.right_button.call_deferred("connect","pressed" , beach_right_click )
	beach.first_texture  = load("res://resources/buttons/beach_world_icon.tres")
	beach.second_texture = load("res://resources/buttons/beach_world_guns_icon.tres")
	beach.third_texture = load("res://resources/buttons/beach_world_shadows_icon.tres")
	beach.world_icon_button.texture_normal = load("res://resources/buttons/beach_world_icon.tres")
	if not OS.has_feature("web"): beach.set_up_mouse_cursors()
	beach.add_all_general_purpose(bounce_shine_shader)
	beach.create_sign_buttons()
	beach.add_children()
	worlds.add_child(beach)

func beach_left_click() -> void:
	match beach.state:
		0:
			global.world_master.change_world(2)
		1: 
			global.world_master.change_world(3)
		2:
			global.world_master.change_world(4)

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
		2:
			beach.world_icon_button.texture_normal = beach.third_texture

func _on_back_button_pressed() -> void:
	menu.switch_menu(0)

func _on_back_button_mouse_entered() -> void:
	back_button.set_deferred("modulate", hover_color)
	global.sound_master.play("button_hover")
	#if not OS.has_feature("web"):Cursor.set_shape(2)


func _on_back_button_mouse_exited() -> void:
	back_button.set_deferred("modulate", reset_color)
	#if not OS.has_feature("web"):Cursor.set_shape(0)
