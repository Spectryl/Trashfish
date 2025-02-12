extends TextureButton

# Deletes aspects of UI if we are on web
func _ready() -> void:
	if OS.has_feature("web"):
		call_deferred("queue_free")
