extends Node2D
var score : int = 0
var high_score : int = 0
var config : ConfigFile

var starve_bar : ProgressBar
var score_ui : Label
var high_score_ui : Label
var health_ui : Label
var player : CharacterBody2D
func _ready() -> void:
	config = ConfigFile.new()
	# Get all the nodes at the beginning, so we don't need to reget em 
	# Also it helps when I inevitablely move shit around
	starve_bar = get_node("CanvasLayer/starve_bar")
	score_ui = get_node("CanvasLayer/Panel/score")
	high_score_ui = get_node("CanvasLayer/Panel/high_score")
	health_ui = get_node("CanvasLayer/Panel/health")
	player = get_node("player")
	$ParallaxBackground/background.play("default")
	
	starve_bar.max_value = player.max_starve
	var error = config.load("user://savedata.cfg")
	if error != OK:
		print("error")
		high_score = 0
	else:
		high_score = config.get_value("player", "classic_high_score", 0)
	
func _process(_delta: float) -> void:
	if player.isDead:
		return
	if score > high_score:
		high_score = score
		config.set_value("player", "classic_high_score", high_score)
		config.save("user://savedata.cfg")
	starve_bar.value = get_player_starvation()
	score_ui.text = "Score: %d" % score
	high_score_ui.text = "High Score: %d" % high_score
	health_ui.text = "X %d" % player.get_health()
	
# heals player from world node to save some brain power
func heal_player():
	get_node("player").increase_health()

# world has access to player pos so comps can access whenever
func get_player_position() -> Vector2:
	return get_node("player").global_position
# world has access to player starvation
func get_player_starvation() -> int:
	return get_node("player").starve

# Final hud update when dead
func update_hud_when_dead():
	score_ui.text = "Score: %d" % score
	health_ui.text = "X %d" % player.get_health()
	config.set_value("player", "classic_high_score", high_score)
	config.save("user://savedata.cfg")
	
	
