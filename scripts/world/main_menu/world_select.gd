extends Control
@onready var menu        : Control              = get_parent()
@onready var back_button : TextureButton        = $back_button
@onready var worlds      : HBoxContainer        = $worlds
var beach                : TwoClickTextureButton
var volcano              : TwoClickTextureButton
var electro              : TwoClickTextureButton
var state : int = 0
var hover_color : Color = Color8(0,255,255,255) # Color when we hover a button
var reset_color : Color = Color8(255,255,255,255)     # Color when we stop hovering, this can be forced to be default color
var bounce_shine_shader = load("res://resources/buttons/world_icon.res")
func _ready() -> void:
	beach = TwoClickTextureButton.new()
	volcano = TwoClickTextureButton.new()
	electro = TwoClickTextureButton.new()

	beach.texture_normal = load("res://resources/buttons/beach_world_icon.tres")
	beach.left_click .connect(_on_beach_left_click_pressed)
	beach.right_click.connect(_on_beach_right_click_pressed)
	beach.material = bounce_shine_shader 
	beach.material.set_shader_parameter("do_abs", false)
	beach.material.set_shader_parameter("do_quantize", true)
	beach.material.set_shader_parameter("sine_amplitude", Vector2(0,20))
	beach.material.set_shader_parameter("sine_speed", Vector2(0,3))

	volcano.texture_normal = load("res://resources/buttons/locked_world_icon.tres")
	volcano.material = bounce_shine_shader
	volcano.material.set_shader_parameter("do_abs", false)
	volcano.material.set_shader_parameter("do_quantize", true)
	volcano.material.set_shader_parameter("sine_amplitude", Vector2(0,20))
	volcano.material.set_shader_parameter("sine_speed", Vector2(0,3))
	
	electro.texture_normal = load("res://resources/buttons/locked_world_icon.tres")
	electro.material = bounce_shine_shader
	electro.material.set_shader_parameter("do_abs", false)
	electro.material.set_shader_parameter("do_quantize", true)
	electro.material.set_shader_parameter("sine_amplitude", Vector2(0,20))
	electro.material.set_shader_parameter("sine_speed", Vector2(0,3))

	worlds.add_child(beach)
	worlds.add_child(volcano)
	worlds.add_child(electro)
	

func _on_beach_left_click_pressed() -> void:
	match state:
		0:
			global.world_master.change_world(2)
		1: 
			global.world_master.change_world(3)
func _on_beach_right_click_pressed() -> void:
	state += 1
	if state > 1: #reset the counter to zero
		state = 0
	# Match the visualness of a button based on our state
	match state:
		0:
			beach.texture_normal = load("res://resources/buttons/beach_world_icon.tres")
		1:
			beach.texture_normal = load("res://resources/buttons/beach_world_guns_icon.tres")


func _on_back_button_pressed() -> void:
	menu.switch_menu(0)

func _on_back_button_mouse_entered() -> void:
	back_button.set_deferred("modulate", hover_color)
	global.sound_master.play("button_hover")


func _on_back_button_mouse_exited() -> void:
	back_button.set_deferred("modulate", reset_color)
