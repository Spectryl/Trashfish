extends TrashShark

## Handles basic player movement
func handle_player_input(delta):
	if not is_rolling:
		direction = Input.get_vector("move_left","move_right","move_up","move_down").normalized()
	direction.x *= -1 if is_controls_flipped else 1
	direction.y *= -1 if is_controls_flipped else 1
	
	velocity.x = lerp(velocity.x, speed * direction.x, acceleration * delta)
	velocity.y = lerp(velocity.y, speed * direction.y * 0.65, acceleration * delta)
	rotation_degrees = 5 if not (abs(self.velocity.y) <= 10) else 0
	rotation_degrees *= -1 if self.velocity.x < 0 else 1
	rotation_degrees *= -1 if self.velocity.y < 0 else 1
