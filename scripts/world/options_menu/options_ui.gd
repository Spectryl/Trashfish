extends Control
@onready var menu : Control = get_parent()

@onready var master_volume_slider : HSlider           = $TabContainer/Sound/master_volume_container/master_volume_slider
@onready var music_volume_slider  : HSlider           = $TabContainer/Sound/master_volume_container/master_volume_slider
@onready var sound_volume_slider  : HSlider           = $TabContainer/Sound/sound_volume_container/sound_volume_slider

@onready var online_check_button     : CheckButton    = $TabContainer/General/MarginContainer/VBoxContainer/HBoxContainer/online_check_button
@onready var smart_player_button     : CheckButton    = $TabContainer/General/MarginContainer/VBoxContainer/HBoxContainer2/smart_player_controls_button
@onready var atk_left_click_button   : CheckButton    = $TabContainer/Controls/HBoxContainer2/atk_left_click_button
@onready var roll_right_click_button : CheckButton    = $TabContainer/Controls/HBoxContainer3/roll_right_click_button
@onready var title_screen_button     : TextureButton  = $title_screen_button

var master_volume : float
var music_volume  : float
var sound_volume  : float

var window_index : int
var resolution_index : int
var vsync_mode : bool
var frame_index : int
func _ready() -> void:
	

	master_volume    = save_master.save_data.get_value("settings",  "master_volume", 1.0)
	music_volume     = save_master.save_data.get_value("settings",  "music_volume" , 1.0)
	sound_volume     = save_master.save_data.get_value("settings",  "sound_volume" , 1.0)
	window_index     = save_master.save_data.get_value("settings",  "window", 0)
	resolution_index = save_master.save_data.get_value("settings",  "resolution", 0)
	vsync_mode       = save_master.save_data.get_value("settings",  "vsync", 1.0)
	frame_index       = save_master.save_data.get_value("settings",  "framerate", 0)
	online_check_button.button_pressed = save_master.save_data.get_value("settings", "online_mode", false)
	smart_player_button.button_pressed = save_master.save_data.get_value("settings", "smart_controls", false)
	atk_left_click_button.button_pressed   = save_master.controls.get_value("controls", "mouse1_attack", false)
	roll_right_click_button.button_pressed = save_master.controls.get_value("controls", "mouse2_roll"  , false)
func _on_texture_button_pressed() -> void:
	#print(db_to_linear(AudioServer.get_bus_volume_db(global.audio_master.master_bus_index)))
	#print(db_to_linear(AudioServer.get_bus_volume_db(global.audio_master.music_bus_index)))
	#print(db_to_linear(AudioServer.get_bus_volume_db(global.audio_master.sound_bus_index)))
	save_master.save_data.set_value("settings", "master_volume", db_to_linear(AudioServer.get_bus_volume_db(global.audio_master.master_bus_index)))
	save_master.save_data.set_value("settings", "music_volume" , db_to_linear(AudioServer.get_bus_volume_db(global.audio_master.music_bus_index)))
	save_master.save_data.set_value("settings", "sound_volume" , db_to_linear(AudioServer.get_bus_volume_db(global.audio_master.sound_bus_index)))
	save_master.save_data.set_value("settings", "window", window_index)
	save_master.save_data.set_value("settings", "resolution", resolution_index)
	save_master.save_data.set_value("settings", "vsync", vsync_mode)
	save_master.save_data.set_value("settings", "framerate", frame_index)
	#save_master.save_data.set_value("controls", "controls", InputMap)
	save_master.save_data.save_encrypted_pass("user://savedata.cfg", save_master.password)
	menu.switch_menu(0)
## from the main_menu_buttons, same exact code basically
func _on_title_screen_button_mouse_entered() -> void:
	title_screen_button.set_deferred("modulate", Color8(0,255,255,255))
	global.sound_master.play("button_hover")
func _on_title_screen_button_mouse_exited() -> void:
	title_screen_button.set_deferred("modulate", Color8(255,255,255,255))
## When we click an option, we should change the screen we are on
func _on_window_type_button_item_selected(index: int) -> void:
	self.window_index = index
	global.game_master.change_display(index)
	global.sound_master.play("button_hover")
## chanegs our resolution, do it by global master so we can reuse this later
func _on_resolution_button_item_selected(index: int) -> void:
	self.resolution_index = index
	global.game_master.change_resolution(index)
	global.sound_master.play("button_hover")
## Controls the vsync if we click or not
func _on_vsyncbutton_toggled(toggled_on: bool) -> void:
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED if toggled_on else DisplayServer.VSYNC_DISABLED)
	vsync_mode = toggled_on
	global.sound_master.play("button_hover")
## Sets fps based on what index of the list we choose
func _on_frame_rate_button_item_selected(index: int) -> void:
	var fps        = (index+1) * 15
	#print(fps)
	Engine.max_fps = fps
	frame_index    = index
	global.sound_master.play("button_hover")


func _on_online_check_button_toggled(toggled_on:bool) -> void:
	save_master.save_data.set_value("settings", "online_mode", toggled_on)
	save_master.save_data.save_encrypted_pass("user://savedata.cfg", save_master.password)
	if toggled_on:
		online_master.turn_on_online()
		online_master.get_results()
	else:
		online_master.turn_off_online()

func _on_smart_player_control_button_toggled(toggled_on:bool) -> void:
	save_master.save_data.set_value("settings", "smart_controls", toggled_on)
	save_master.save_data.save_encrypted_pass("user://savedata.cfg", save_master.password)

func _on_atk_left_click_button_toggled(toggled_on:bool) -> void:
	save_master.controls.set_value("controls", "mouse1_attack", toggled_on)
	save_master.controls.save_encrypted_pass("user://controls.cfg", save_master.password)
	if toggled_on:
		var event := InputEventMouseButton.new()
		event.button_index = MOUSE_BUTTON_LEFT
		event.pressed = true 
		if not InputMap.has_action("attack"):
			InputMap.add_action("attack")
		InputMap.action_add_event("attack", event)
	else:
		for event in InputMap.action_get_events("attack"):
			if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
				InputMap.action_erase_event("attack", event)


func _on_roll_right_click_button_toggled(toggled_on: bool) -> void:
	save_master.controls.set_value("controls", "mouse2_roll", toggled_on)
	save_master.controls.save_encrypted_pass("user://controls.cfg", save_master.password)
	if toggled_on:
		var event := InputEventMouseButton.new()
		event.button_index = MOUSE_BUTTON_RIGHT
		event.pressed = true 
		if not InputMap.has_action("roll"):
			InputMap.add_action("roll")
		InputMap.action_add_event("roll", event)
	else:
		for event in InputMap.action_get_events("roll"):
			if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
				InputMap.action_erase_event("roll", event)
