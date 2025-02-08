extends AnimatedSprite2D


func _ready() -> void:
	var new_color = Color(randf_range(0,1), randf_range(0,1), randf_range(0,1), 1.0)
	material.set_shader_parameter("u_replacement_color", new_color)
