extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self_modulate = Color8(randi_range(0,255), randi_range(0,255), randi_range(0,255), 255)
