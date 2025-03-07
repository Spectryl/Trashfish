extends Node

const simpleboards_scene = preload("res://addons/simpleboards_plugin/simple_boards.tscn")

var simpleboards : Node2D

const api_key : String = "f70edd68-7a2f-4bd1-a84d-4ba99358dda8"
const leaderboard_key : String = "7dc916e3-eb5b-4bad-0f51-08dd59d342af"

var data



func set_key() -> void:
	simpleboards.simpleboards.set_api_key(api_key)

func get_results():
	await simpleboards.simpleboards.get_entries(leaderboard_key)

func _on_entries_got(entries):
	data = entries
	print(data)

func turn_on_online() -> void:
	
	simpleboards = simpleboards_scene.instantiate()

	add_child(simpleboards)
	set_key()
	simpleboards.simpleboards.entries_got.connect(_on_entries_got)

func turn_off_online() -> void:
	simpleboards.queue_free()

func send_data(score : int):
	await simpleboards.simpleboards.send_score_without_id(leaderboard_key, save_master.save_data.get_value("player", "player_name", "player"), str(score), "{}")
