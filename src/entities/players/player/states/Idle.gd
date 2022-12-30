extends State

func enter(_msg := {}) -> void:
	if owner.get_animation_player("Movement").current_animation == "Decel":
		await owner.get_animation_player("Movement").animation_finished
	owner.play_animation("Idle", "Movement")

func physics_update(_delta: float) -> void:
	if owner.health_manager.is_dead(): state_machine.transition_to("Death")
	
	if owner.interacting:
		state_machine.transition_to("Interacting")
	
	var input_direction := Vector2.ZERO
	input_direction.x = Input.get_action_strength("right" + owner.player_id) - Input.get_action_strength("left" + owner.player_id)
	input_direction.y = Input.get_action_strength("down" + owner.player_id) - Input.get_action_strength("up" + owner.player_id)
	
	
	if input_direction.x != 0 or input_direction.y != 0:
		state_machine.transition_to("Move")
