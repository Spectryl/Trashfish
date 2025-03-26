class_name WorldSelect
extends VBoxContainer

var world_icon_button : TwoClickTextureButton
var texture_rect      : TextureRect           
var left_button       : TextureButton        
var right_button      : TextureButton       

@export var first_texture  : Resource
@export var second_texture : Resource
@export var third_texture  : Resource
@export var fourth_texture : Resource

@export var max_gamemodes: int    = 1

var state : int = 0

## Creates the Green and Red Buttons VISUALLY
func create_sign_buttons() -> void:
	left_button.texture_normal = load("res://resources/buttons/gamemode_red_normal.tres")
	left_button.texture_hover  = load("res://resources/buttons/gamemode_red_hover.tres")
	left_button.texture_pressed= load("res://resources/buttons/gamemode_red_pressed.tres")
	
	right_button.texture_normal = load("res://resources/buttons/gamemode_green_normal.tres")
	right_button.texture_hover  = load("res://resources/buttons/gamemode_green_hover.tres")
	right_button.texture_pressed= load("res://resources/buttons/gamemode_green_pressed.tres")
	
	left_button.size = Vector2(79,87)
	left_button.position = Vector2(19, 38.25)
	left_button.use_parent_material = true
	
	right_button.size = Vector2(79,87)
	right_button.position = Vector2(110.41, 38.25)
	right_button.use_parent_material = true

## Adds all children to the scene
func add_children() -> void:
	add_child(world_icon_button)
	texture_rect.add_child(left_button)
	texture_rect.add_child(right_button)
	add_child(texture_rect)

## Creates all the children we need
func create_children() -> void:
	world_icon_button = TwoClickTextureButton.new()
	texture_rect = TextureRect.new()
	left_button  = TextureButton.new()
	right_button = TextureButton.new()
	
	
func add_all_general_purpose(bounce_shine_shader : String) -> void:
	add_theme_constant_override("separation", -8)
	world_icon_button.material = load(bounce_shine_shader)
	world_icon_button.material.set_shader_parameter("do_abs", false)
	world_icon_button.material.set_shader_parameter("do_quantize", true)
	world_icon_button.material.set_shader_parameter("sine_amplitude", Vector2(0,10))
	world_icon_button.material.set_shader_parameter("sine_speed", Vector2(0,4))
	world_icon_button.material.set_shader_parameter("time_offset", 55.0)
	texture_rect.texture = load("res://resources/buttons/gamemode_selection_background.res")
	texture_rect.material = load("res://resources/buttons/gamemode_icon_bounce.res")

func set_up_mouse_cursors() -> void:
	world_icon_button.connect("mouse_entered", set_pointer_mouse.bind(2))
	left_button      .connect("mouse_entered", set_pointer_mouse.bind(2))
	right_button     .connect("mouse_entered", set_pointer_mouse.bind(2))
	
	world_icon_button.connect("mouse_exited", set_pointer_mouse.bind(0))
	left_button      .connect("mouse_exited", set_pointer_mouse.bind(0))
	right_button     .connect("mouse_exited", set_pointer_mouse.bind(0))
	

func set_pointer_mouse(i : int) -> void:
	Cursor.set_shape(i)
