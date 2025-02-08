extends TextureButton

func _ready() -> void:
	call_deferred("grab_focus")
	call_deferred("grab_click_focus")
