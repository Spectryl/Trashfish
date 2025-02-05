extends Control
@onready var menu : Control = get_parent()

@onready var master_volume_slider : HSlider = $TabContainer/Sound/master_volume_container/master_volume_slider
@onready var music_volume_slider  : HSlider = $TabContainer/Sound/master_volume_container/master_volume_slider
@onready var sound_volume_slider  : HSlider = $TabContainer/Sound/sound_volume_container/sound_volume_slider

@onready var title_screen_button  : TextureButton = $title_screen_button

var config : ConfigFile
var master_volume : float
var music_volume  : float
var sound_volume  : float

var window_index : int
var resolution_index : int
var vsync_mode : bool
func _ready() -> void:
	config = ConfigFile.new()
	var error = config.load("user://savedata.cfg")
	if error != OK:
		print("error:", error)
		master_volume = 1.0
		music_volume  = 1.0
		sound_volume  = 1.0
		window_index = 0
		resolution_index = 0
		vsync_mode = 1
	else:
		master_volume    = config.get_value("settings",  "master_volume", 1.0)
		music_volume     = config.get_value("settings",  "music_volume" , 1.0)
		sound_volume     = config.get_value("settings",  "sound_volume" , 1.0)
		window_index     = config.get_value("settings",  "window", 0)
		resolution_index = config.get_value("settings",  "resolution", 0)
		vsync_mode       = config.get_value("settings",  "vsync", 1.0)

func _on_texture_button_pressed() -> void:
	#print(db_to_linear(AudioServer.get_bus_volume_db(global.audio_master.master_bus_index)))
	#print(db_to_linear(AudioServer.get_bus_volume_db(global.audio_master.music_bus_index)))
	#print(db_to_linear(AudioServer.get_bus_volume_db(global.audio_master.sound_bus_index)))
	config.set_value("settings", "master_volume", db_to_linear(AudioServer.get_bus_volume_db(global.audio_master.master_bus_index)))
	config.set_value("settings", "music_volume" , db_to_linear(AudioServer.get_bus_volume_db(global.audio_master.music_bus_index)))
	config.set_value("settings", "sound_volume" , db_to_linear(AudioServer.get_bus_volume_db(global.audio_master.sound_bus_index)))
	config.set_value("settings", "window", window_index)
	config.set_value("settings", "resolution", resolution_index)
	config.set_value("settings", "vsync", vsync_mode)
	config.save("user://savedata.cfg")
	menu.switch_menu(0)

func _on_title_screen_button_mouse_entered() -> void:
	title_screen_button.set_deferred("modulate", Color(255,0,0,255))
	global.sound_master.play("button_hover")

func _on_title_screen_button_mouse_exited() -> void:
	title_screen_button.set_deferred("modulate", Color(1,1,1,1))

# When we click an option, we should change the screen we are on
func _on_window_type_button_item_selected(index: int) -> void:
	self.window_index = index
	global.game_master.change_display(index)
	global.sound_master.play("button_hover")
	
func _on_resolution_button_item_selected(index: int) -> void:
	self.resolution_index = index
	global.game_master.change_resolution(index)
	global.sound_master.play("button_hover")
	
func _on_vsyncbutton_toggled(toggled_on: bool) -> void:
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED if toggled_on else DisplayServer.VSYNC_DISABLED)
	vsync_mode = toggled_on
	global.sound_master.play("button_hover")
