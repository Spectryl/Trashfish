extends Node2D

@onready var simpleboards = $SimpleBoardsApi

func _ready():
	# Set the API key
	simpleboards.set_api_key("f70edd68-7a2f-4bd1-a84d-4ba99358dda8")

	global.simple_boards = simpleboards
	
	# Send a score
	#await simpleboards.send_score_without_id("7dc916e3-eb5b-4bad-0f51-08dd59d342af", "IHateNiggers", "55", "[]")
	#await simpleboards.send_score_with_id("7dc916e3-eb5b-4bad-0f51-08dd59d342af", "PlayerName", "12345", "[]", "1")
	
	# Get leaderboard entries
	#await simpleboards.get_entries("7dc916e3-eb5b-4bad-0f51-08dd59d342af")

func _on_entries_got(entries):
	for entry in entries:
		print(entry)
	
func _on_entry_sent(entry):
	pass
	#print(entry)
