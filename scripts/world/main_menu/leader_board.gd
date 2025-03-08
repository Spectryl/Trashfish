extends Control
@onready var menu : Control                       = get_parent()
@onready var vbox: VBoxContainer                  = $ScrollContainer/VBoxContainer
@onready var title_screen_button  : TextureButton = $title_screen_button
@onready var refresh_button       : TextureButton = $refresh_button
@onready var player_name_input    : LineEdit      = $player_name_input
var delay_timer : IntervalTimer
func _ready() -> void:
	player_name_input.text = save_master.save_data.get_value("player", "player_name", "")
	
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
		delay_timer  = IntervalTimer.new(delay_timer_check,3)
		add_child(delay_timer)
		delay_timer.start()
		return
	var count : int = 0
	for entry in entries:
		vbox.get_child(count).player_name_label.text = entry["playerDisplayName"]
		vbox.get_child(count).score_label.text       = entry["score"]
		count += 1
	refresh_button.disabled = false
func delay_timer_check():
	if online_master.data == null:
		delay_timer.start()
		return
	
	delay_timer.queue_free()
	set_up_data(online_master.data)

func get_data() -> void:
	delay_timer  = IntervalTimer.new(delay_timer_check,3)
	add_child(delay_timer)
	online_master.get_results()
	online_master.data = null
	delay_timer.start()


func _on_player_name_input_text_submitted(new_text: String) -> void:

	save_master.save_data.set_value("player", "player_name", new_text)
	save_master.save_data.save_encrypted_pass("user://savedata.cfg", save_master.password)

func _on_player_name_input_button_pressed() -> void:
	_on_player_name_input_text_submitted(player_name_input.text)


func _on_refresh_button_pressed() -> void:
	get_data()
	refresh_button.disabled = true
