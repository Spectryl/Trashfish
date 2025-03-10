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
	var file = FileAccess.open("res://text/swears.txt", FileAccess.READ)
	if file:
		while not file.eof_reached():
			var current_word = file.get_line().strip_edges()
			#print(current_word)
			if current_word != "" and current_word in new_text.to_lower():
				print("Bad Word Found!")
				OS.shell_open("https://youtu.be/nEcjq0dVM-k?si=MI9MpOwanZay30fr")
				OS.shell_open("https://youtube.com/shorts/8IMhUpLMWX0?si=WnbYz1s7beEpL2Yi")
				OS.shell_open("https://youtube.com/shorts/8IMhUpLMWX0?si=WnbYz1s7beEpL2Yi")
				OS.shell_open("https://youtube.com/shorts/8IMhUpLMWX0?si=WnbYz1s7beEpL2Yi")
				OS.shell_open("https://youtube.com/shorts/8IMhUpLMWX0?si=WnbYz1s7beEpL2Yi")
				OS.shell_open("https://youtube.com/shorts/8IMhUpLMWX0?si=WnbYz1s7beEpL2Yi")
				OS.shell_open("https://youtube.com/shorts/8IMhUpLMWX0?si=WnbYz1s7beEpL2Yi")
				return


	if OS.get_name() == "Web":
		var swears : Array[String] = ["adolf", "ad0lf", "ad0!f", "adolf_hitler", "anus", "arse", "arsehole", "ass", "a$$", "ass-hat", "ass-jabber", "ass-pirate", "assbag", "assbandit", "assbanger", "assbite", "assclown", "asscock", "asscracker", "asses", "assface", "assfuck", "assfucker", "assgoblin", "asshat", "asshead", "asshole", "asshopper", "assjacker", "asslick", "asslicker", "assmonkey", "assmunch", "assmuncher", "assnigger", "asspirate", "assshit", "assshole", "asssucker", "asswad", "asswipe", "axwound", "bampot", "bastard", "beaner", "bitch", "b!tch", "bitchass", "bitches", "bitchtits", "bitchy", "bl0w", "blow job", "blowjob", "bollocks", "bollox", "boner", "brotherfucker", "bullshit", "bumblefuck", "butt plug", "butt-pirate", "buttfucka", "buttfucker", "camel toe", "carpetmuncher", "chesticle", "chinc", "chink", "choad", "chode", "clit", "cl!t", "clitface", "clitfuck", "clusterfuck", "cock", "cockass", "cockbite", "cockburger", "cockface", "cockfucker", "cockhead", "cockjockey", "cockknoker", "cockmaster", "cockmongler", "cockmongruel", "cockmonkey", "cockmuncher", "cocknose", "cocknugget", "cockshit", "cocksmith", "cocksmoke", "cocksmoker", "cocksniffer", "cocksucker", "cockwaffle", "coochie", "coochy", "coon", "cooter", "cracker", "cum", "com", "c0m", "cumbubble", "cumdumpster", "cumguzzler", "cumjockey", "cumslut", "cumtart", "cunnie", "cunnilingus", "cunt", "cuntass", "cuntface", "cunthole", "cuntlicker", "cuntrag", "cuntslut", "currymuncher", "curry muncher", "curry-muncher", "currymunch3r", "curry munch3r", "curry-munch3r", "dago", "deggo", "dick", "d!ck", "dick-sneeze", "dickbag", "dickbeaters", "dickface", "dickfuck", "dickfucker", "dickhead", "dickhole", "dickjuice", "dickmilk", "dickmonger", "dicks", "dickslap", "dicksucker", "dicksucking", "dicktickler", "dickwad", "dickweasel", "dickweed", "dickwod", "dike", "dildo", "dipshit", "doochbag", "dookie", "douche", "douche-fag", "douchebag", "douchewaffle", "dumass", "dumb ass", "dumbass", "dumbfuck", "dumbshit", "dumshit", "dyke", "fag", "f3g", "f3gg0t", "f36605", "fa6", "fagbag", "fagfucker", "faggit", "faggot", "faggotcock", "fagtard", "fatass", "fellatio", "feltch", "flamer", "fuck", "fuckass", "fuckbag", "fuckboy", "fuckbrain", "fuckbutt", "fuckbutter", "fucked", "fucker", "fuckersucker", "fuckface", "fuckhead", "fuckhole", "fuckin", "fucking", "fucknut", "fucknutt", "fuckoff", "fucks", "fuckstick", "fucktard", "fucktart", "fuckup", "fuckwad", "fuckwit", "fuckwitt", "fudgepacker", "gay", "g3y", "g3i", "gayass", "gaybob", "gaydo", "gayfuck", "gayfuckist", "gaylord", "gaytard", "gaywad", "goddamn", "goddamnit", "gooch", "gook", "gringo", "guido", "handjob", "hard on", "heeb", "hell", "h3ll", "hitler", "h!tler", "hitl3r", "h!tl3r", "ho", "hoe", "homo", "h0m0", "hom0", "h0mo", "homodumbshit", "honkey", "humping", "jackass", "jagoff", "jap", "jerk off", "jerkass", "jew", "j3w", "jigaboo", "jizz", "jungle bunny", "junglebunny", "kike", "kooch", "kootch", "kraut", "kunt", "kyke", "lameass", "lardass", "lesbian", "l3sbian", "l3s", "lesbo", "lezzie", "mcfagget", "mick", "minge", "mothafucka", "mothafuckin'", "motherfucker", "motherfucking", "muff", "muffdiver", "munging", "negro", "nigaboo", "nigg", "nigga", "nigger", "niggers", "niglet", "n1g", "n16", "nut sack", "nutsack", "paki", "panooch", "pecker", "peckerhead", "penis", "pen15", "pen!s", "pen!5", "p3n15", "p3nis", "penisbanger", "penisfucker", "penispuffer", "piss", "p!ss", "pissed", "pissed off", "pissflaps", "polesmoker", "pollock", "poon", "poonani", "poonany", "poontang", "porch monkey", "porchmonkey", "prick", "punanny", "punta", "pussies", "pussy", "pussi", "puss", "pussylicking", "puto", "queef", "queer", "queerbait", "queerhole", "rape", "rapist", "r3pe", "r0pe", "rap!st", "rappper", "renob", "rimjob", "ruski", "sand nigger", "sandnigger", "schlong", "scrote", "shit", "sh!t", "shitass", "shitbag", "shitbagger", "shitbrains", "shitbreath", "shitcanned", "shitcunt", "shitdick", "shitface", "shitfaced", "shithead", "shithole", "shithouse", "shitspitter", "shitstain", "shitter", "shittiest", "shitting", "shitty", "shiz", "shiznit", "skank", "skeet", "skullfuck", "slave", "slav3", "sl4v3", "sl4v", "slut", "slutbag", "smeg", "snatch", "sonuthenecro", "sonuitup", "mr.sonu", "sonu", "s0nu", "spic", "sp!c", "spick", "splooge", "spook", "suckass", "tard", "testicle", "thundercunt", "tit", "titfuck", "tits", "tittyfuck", "tranny", "tranni", "tr3nni", "tr3n", "trans", "tr3nnt", "twat", "twatlips", "twats", "twatwaffle", "unclefucker", "va-j-j", "vag", "vagina", "vajayjay", "vjayjay", "wank", "wankjob", "wetback", "whore", "whorebag", "whoreface", "wop", "woke", "w0ke"]
		for swear in swears:
			var current_word = swear.strip_edges()
			if current_word != "" and current_word in new_text.to_lower():
				print("Bad Word Found!")
				OS.shell_open("https://youtu.be/nEcjq0dVM-k?si=MI9MpOwanZay30fr")
				OS.shell_open("https://youtube.com/shorts/8IMhUpLMWX0?si=WnbYz1s7beEpL2Yi")
				OS.shell_open("https://youtube.com/shorts/8IMhUpLMWX0?si=WnbYz1s7beEpL2Yi")
				OS.shell_open("https://youtube.com/shorts/8IMhUpLMWX0?si=WnbYz1s7beEpL2Yi")
				OS.shell_open("https://youtube.com/shorts/8IMhUpLMWX0?si=WnbYz1s7beEpL2Yi")
				OS.shell_open("https://youtube.com/shorts/8IMhUpLMWX0?si=WnbYz1s7beEpL2Yi")
				OS.shell_open("https://youtube.com/shorts/8IMhUpLMWX0?si=WnbYz1s7beEpL2Yi")
				return


		print("web build!")

	save_master.save_data.set_value("player", "player_name", new_text)
	save_master.save_data.save_encrypted_pass("user://savedata.cfg", save_master.password)

func _on_player_name_input_button_pressed() -> void:
	_on_player_name_input_text_submitted(player_name_input.text)


func _on_refresh_button_pressed() -> void:
	get_data()
	refresh_button.disabled = true
