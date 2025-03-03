extends Node2D

@onready var simpleboards = $SimpleBoardsApi

func _ready():
	simpleboards.set_api_key("f70edd68-7a2f-4bd1-a84d-4ba99358dda8")
	global.simple_boards = simpleboards


func _on_entries_got(entries):
	for entry in entries:
		print(entry)
	
