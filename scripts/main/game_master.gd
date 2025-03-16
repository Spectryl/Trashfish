extends Node2D
@onready var world : Node2D
@onready var player : CharacterBody2D
@onready var audio_master  : Node2D = $audio_master
@onready var player_master : Node2D = $player_master
@onready var world_master  : Node2D = $world_master

const resolutions : Dictionary = {
	"640x480"   = Vector2i(640 ,480),
	"780x480"   = Vector2i(720 ,480),
	"1280x720"  = Vector2i(1280, 720),
	"1920x1080" = Vector2i(1920,1080),
	"2560x1440" = Vector2i(2560,1440),
	"3440x1440" = Vector2i(3440,1440),
	"3840x2160" = Vector2i(3840,2160)
}
var control_list : Array[String] = ["move_left", "move_right", "move_up", "move_down", "attack", "roll"]
func _ready() -> void:
	if OS.has_environment("USERNAME") and OS.get_environment("USERNAME").to_lower().count("Carl", 0,0) == 0:
		if not OS.is_debug_build:
			queue_free()
		#OS.crash("In order to remain ICE Compliant, this user is BANNED from all SonuTheNecro LTD Media")
		#OS.shell_open("https://www.youtube.com/shorts/8IMhUpLMWX0")
		#OS.shell_open("https://discord.gg/PeD2cvjgt9")
	if OS.is_debug_build():
		print("DEBUG BUILD")
		save_master.save_data.set_value("player", "player_name", "dev_build" + ProjectSettings.get_setting("application/config/version"))
		save_master.save_data.save_encrypted_pass("user://savedata.cfg", save_master.password)
	
	global.game_master = self
	audio_master.set_up_audio(save_master.password)
	change_display(save_master.save_data.get_value("settings", "window", 1))
	change_resolution(save_master.save_data.get_value("settings", "resolution", 2))
	set_controls()
	if save_master.save_data.get_value("settings", "online_mode", false):
		online_master.turn_on_online()
		online_master.get_results()


func change_display(index : int) -> void:
	match index:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		2:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)

func change_resolution(index : int) -> void:
	DisplayServer.window_set_size(resolutions.values()[index])
	var centre_screen = DisplayServer.screen_get_position() + DisplayServer.screen_get_size()/2
	var window_size = get_window().get_size_with_decorations()
	get_window().set_position(centre_screen - window_size/2)

func set_controls() -> void:
	for i in range(len(control_list)):
		var action_name = control_list[i]
		var action_event= InputMap.action_get_events(action_name)[0]
		var event = save_master.controls.get_value("controls", action_name, action_event.physical_keycode)
		var newKey = InputEventKey.new()
		newKey.set_keycode(event)
		newKey.set_pressed(true)
		InputMap.action_erase_events(action_name)
		InputMap.action_add_event(action_name, newKey)
	
	if save_master.controls.get_value("controls", "mouse1_attack", false):
		var event := InputEventMouseButton.new()
		event.button_index = MOUSE_BUTTON_LEFT
		event.pressed = true 
		if not InputMap.has_action("attack"):
			InputMap.add_action("attack")
		InputMap.action_add_event("attack", event)
