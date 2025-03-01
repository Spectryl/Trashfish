extends Node2D
# Attach this to a node if we aren't on the debug build
# use this for things that are still being made/produced so pre-release features are not in main buids


func _ready() -> void:
	if not OS.is_debug_build(): 
		get_parent().call_deferred("queue_free")
	call_deferred("queue_free")
