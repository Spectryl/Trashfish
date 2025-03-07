extends Control
@onready var menu : Control                       = get_parent()
@onready var vbox: VBoxContainer                  = $ScrollContainer/VBoxContainer
@onready var title_screen_button  : TextureButton = $title_screen_button
@onready var player_name_input    : LineEdit      = $player_name_input
var delay_timer : Timer
func _ready() -> void:
	player_name_input.text = save_master.save_data.get_value("player", "player_name", "")
	delay_timer  = Timer.new()
	delay_timer .wait_time = 3
	delay_timer .timeout.connect(delay_timer_check)
	delay_timer .one_shot = true
	delay_timer .autostart = false
	add_child(delay_timer)

	set_up_data(online_master.data)

func _on_title_screen_button_pressed() -> void:
	menu.switch_menu(0)

func _on_title_screen_button_mouse_entered() -> void:
	title_screen_button.set_deferred("modulate", Color8(0,255,255,255))
	global.sound_master.play("button_hover")
func _on_title_screen_button_mouse_exited() -> void:
	title_screen_button.set_deferred("modulate", Color8(255,255,255,255))


func set_up_data(entries):
	if entries == null:
		delay_timer.start()
		return
	var count : int = 0
	for entry in entries:
		vbox.get_child(count).player_name_label.text = entry["playerDisplayName"]
		vbox.get_child(count).score_label.text       = entry["score"]
		count += 1
func delay_timer_check():
	if online_master.data == null:
		delay_timer.start()
		return
	
	delay_timer.queue_free()
	set_up_data(online_master.data)

func _on_player_name_input_text_submitted(new_text: String) -> void:

	save_master.save_data.set_value("player", "player_name", new_text)
	save_master.save_data.save_encrypted_pass("user://savedata.cfg", save_master.password)

func _on_player_name_input_button_pressed() -> void:
	_on_player_name_input_text_submitted(player_name_input.text)
