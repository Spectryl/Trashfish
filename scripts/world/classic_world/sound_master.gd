extends Node
@onready var bloop : AudioStreamPlayer = $bloop

var sound_dictionary = {
	"bloop" : bloop,
	
}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func play(sfx_name : String):
	sound_dictionary[sfx_name].play()
