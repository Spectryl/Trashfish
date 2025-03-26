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

func add_children() -> void:
	add_child(world_icon_button)
	texture_rect.add_child(left_button)
	texture_rect.add_child(right_button)
	add_child(texture_rect)
