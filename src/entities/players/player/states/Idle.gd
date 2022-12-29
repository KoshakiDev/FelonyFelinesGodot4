extends State

func enter(_msg := {}) -> void:
	if owner.get_animation_player("Movement").current_animation == "Decel":
		await owner.get_animation_player("Movement").animation_finished
	owner.play_animation("Idle", "Movement")

func physics_update(_delta: float) -> void:
	if owner.health_manager.is_dead(): state_machine.transition_to("Death")
	
	if owner.interacting:
		state_machine.transition_to("Interacting")
	
	if Input.is_action_pressed("left" + owner.player_id) or Input.is_action_pressed("right" + owner.player_id) or Input.is_action_just_pressed("up" + owner.player_id) or Input.is_action_pressed("down" + owner.player_id):
		state_machine.transition_to("Move")
