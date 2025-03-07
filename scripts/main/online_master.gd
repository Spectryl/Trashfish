extends Node

const simpleboards_scene = preload("res://addons/simpleboards_plugin/simple_boards.tscn")

var simpleboards : Node2D
## keys
const api_key : String = "f70edd68-7a2f-4bd1-a84d-4ba99358dda8"
const leaderboard_key : String = "7dc916e3-eb5b-4bad-0f51-08dd59d342af"

var data ## where we store the dictionary


## This sets the key for simpleboards so it knows which account to use
func set_key() -> void:
	simpleboards.simpleboards.set_api_key(api_key)
## run this command to get a fresh copy of leaderboard entries
func get_results():
	await simpleboards.simpleboards.get_entries(leaderboard_key)

## Stores the data we get from get_results() so we can store it and not do 500000 calls
func _on_entries_got(entries):
	data = entries
	#print(data)

## run this command to turn the connection on
func turn_on_online() -> void:
	simpleboards = simpleboards_scene.instantiate()
	add_child(simpleboards)
	set_key()
	simpleboards.simpleboards.entries_got.connect(_on_entries_got)

## run this command to turn the connect off
func turn_off_online() -> void:
	simpleboards.queue_free()

## Check to see if we should even run this, only run if this we are turned on (the server)
func send_data(score : int):
	await simpleboards.simpleboards.send_score_without_id(leaderboard_key, save_master.save_data.get_value("player", "player_name", "player"), str(score), "{}")
