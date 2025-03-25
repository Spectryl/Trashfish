extends TrashShark

## Handles basic player movement
# @Override
func handle_player_input(delta):
	if not is_rolling:
		direction = Input.get_vector("move_left","move_right","move_up","move_down").normalized()
		global_rotation = global_position.angle_to_point(get_global_mouse_position())
		global_rotation *= -1 if is_controls_flipped else 1
	direction.x *= -1 if is_controls_flipped else 1
	direction.y *= -1 if is_controls_flipped else 1
	
	velocity.x = lerp(velocity.x, speed * direction.x, acceleration * delta)
	velocity.y = lerp(velocity.y, speed * direction.y * 0.65, acceleration * delta)
	#global_rotation = lerp(global_rotation, global_position.angle_to_point(get_global_mouse_position()), turn_speed * delta )
	#print(global_rotation)
	flip(true)


##Flip the animations and hitboxes
# @Override
func flip(_new_value : bool) -> void:
	body.flip_v = 1 if abs(self.global_rotation) > 1.57 else 0
	head.flip_v = 1 if abs(self.global_rotation) > 1.57 else 0
	honey_sprite.flip_v = 1 if abs(self.global_rotation) > 1.57 else 0
	ice_sprite.flip_v = 1 if abs(self.global_rotation) > 1.57 else 0
	#print(global_rotation)
	return
