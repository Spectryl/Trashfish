extends Node2D


# delets the graphics tab since its useless in web
# Attach to thing we wanna test to delete, then delete this node
func _ready() -> void:
	if OS.has_feature("web"): 
		get_parent().call_deferred("queue_free")
	call_deferred("queue_free")
