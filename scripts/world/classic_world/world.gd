extends Node2D
var score : int = 0: set = update_score_hud
var high_score : int = 0: set = update_high_score_hud
var health : int = 0: set = update_health_hud
var config : ConfigFile


var world_id = 2 

@onready var starve_bar : ProgressBar          = $CanvasLayer/starve_bar
@onready var score_ui : Label                  = $CanvasLayer/Panel/score
@onready var high_score_ui : Label             = $CanvasLayer/Panel/high_score
@onready var health_ui : Label                 = $CanvasLayer/Panel/health
@onready var sun_player : AnimationPlayer      = $ParallaxBackground/sun/sun_animator

@onready var ship_master : Node2D              = $ship_master
@onready var fish_master : Node2D              = $fish_master

@onready var player : CharacterBody2D          = global.player
@onready var sound_master : Node               = global.sound_master
func _ready() -> void:
	
	sun_player.play("rotate_sun")
	config = ConfigFile.new()

	
	health = player.get_health()
	starve_bar.max_value = player.max_starve
	var error = config.load_encrypted_pass("user://savedata.cfg",global.game_master.password)
	if error != OK:
		print("error")
		high_score = 0
	else:
		high_score = config.get_value("player", "beach_classic_high_score", 0)
		
	generate_waves()
	generate_pebbles()
	generate_seashells()
	generate_seaweed()
	
func _process(_delta: float) -> void:
	if player.is_dead:
		return
	if score > high_score:
		high_score = score
		config.set_value("player", "beach_classic_high_score", high_score)
		config.save_encrypted_pass("user://savedata.cfg", global.game_master.password)
	starve_bar.value = get_player_starvation()
	var player_health = player.get_health()
	if health != player_health:
		health = player_health
	
# heals player from world node to save some brain power
func heal_player():
	player.increase_health()

# world has access to player pos so comps can access whenever
func get_player_position() -> Vector2:
	return player.global_position
# world has access to player starvation
func get_player_starvation() -> int:
	return player.starve

# Final hud update when dead
func update_hud_when_dead():
	score_ui.text = "Score: %d" % score
	health_ui.text = "X %d" % player.get_health()
	config.set_value("player", "beach_classic_high_score", high_score)
	config.save_encrypted_pass("user://savedata.cfg", global.game_master.password)

	starve_bar.queue_free()
	score_ui.queue_free()
	high_score_ui.queue_free()
	health_ui.queue_free()
	var a = load("res://scenes/misc/death_score_scene.tscn").instantiate()
	a.score_str = "SCORE: %d" % score
	add_child(a)


	
func update_score_hud(new_score : int):
	score = new_score
	if score == 70:
		fish_master.process_mode = Node.PROCESS_MODE_INHERIT

	score_ui.text = "Score: %d" % score
	
func update_high_score_hud(new_high_score : int):
	high_score = new_high_score
	high_score_ui.text = "High Score: %d" % high_score
	
func update_health_hud(new_health : int):
	health = new_health
	health_ui.text = "X %d" % health
	
func generate_waves():
	var waves_sprite = load("res://scenes/world/classic_world/waves.tscn")
	for i in range(20):
		var new_wave = waves_sprite.instantiate()
		new_wave.play("default")
		new_wave.global_position = Vector2(i * 100, 200)
		new_wave.z_index = 99
		new_wave.scale.y += randf_range(0,2)
		add_child(new_wave)

func generate_pebbles():
	var pebble_sprite = load("res://scenes/world/classic_world/pebble.tscn")
	for i in range(50):
		var new_pebble = pebble_sprite.instantiate()
		new_pebble.global_position = Vector2(randi_range(20,1960), randi_range(1011, 1075))
		add_child(new_pebble)

func generate_seashells():
	var seashell_scene = load("res://scenes/world/classic_world/seashell.tscn")
	for i in randi_range(5,10):
		var new_seashell = seashell_scene.instantiate()
		new_seashell.global_position = Vector2(randi_range(20,1960), randi_range(1022, 1075))
		add_child(new_seashell)

func generate_seaweed():
	var sea_weed_scene = load("res://scenes/world/classic_world/seaweed.tscn")
	var total_weed = randi_range(12,16)
	
	for i in range(total_weed):
		var isInRange : bool = false
		var test_global_position : Vector2 = Vector2(randi_range(20, 1960), 1003)
		for node in get_children():
			if node.is_in_group("seaweed"):
				if check_in_range(test_global_position.x, node.global_position.x, 45):
					isInRange = true
					break
		
		if not isInRange:
			var new_weed = sea_weed_scene.instantiate()
			new_weed.global_position = test_global_position
			add_child(new_weed)
	

func check_in_range(a : float, b : float , range_of_pos : float) -> bool:
	return abs(a - b) < range_of_pos + 1
