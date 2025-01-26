extends Node2D
var score : int = 0: set = update_score_hud
var high_score : int = 0: set = update_high_score_hud
var health : int = 0: set = update_health_hud
var config : ConfigFile

var world_id = 2 #would be better if composition was used here but its one variable

@onready var starve_bar : ProgressBar          = $CanvasLayer/starve_bar
@onready var score_ui : Label                  = $CanvasLayer/Panel/score
@onready var high_score_ui : Label             = $CanvasLayer/Panel/high_score
@onready var health_ui : Label                 = $CanvasLayer/Panel/health
@onready var player : CharacterBody2D          = global.player
@onready var sound_master : Node               = global.sound_master
func _ready() -> void:
	
	
	config = ConfigFile.new()

	
	health = player.get_health()
	$ParallaxBackground/background.play("default")
	starve_bar.max_value = player.max_starve
	var error = config.load("user://savedata.cfg")
	if error != OK:
		print("error")
		high_score = 0
	else:
		high_score = config.get_value("player", "classic_high_score", 0)
	
func _process(_delta: float) -> void:
	if player.is_dead:
		return
	if score > high_score:
		high_score = score
		config.set_value("player", "classic_high_score", high_score)
		config.save("user://savedata.cfg")
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
	config.set_value("player", "classic_high_score", high_score)
	config.save("user://savedata.cfg")
	
func update_score_hud(new_score : int):
	score = new_score
	score_ui.text = "Score: %d" % score
	
func update_high_score_hud(new_high_score : int):
	high_score = new_high_score
	high_score_ui.text = "High Score: %d" % high_score
	
func update_health_hud(new_health : int):
	health = new_health
	health_ui.text = "X %d" % health
	
