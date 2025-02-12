extends TabBar


# delets the graphics tab since its useless in web
func _ready() -> void:
	if OS.has_feature("web"):
		call_deferred("queue_free")
