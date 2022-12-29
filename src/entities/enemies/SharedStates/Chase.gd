extends State

#Shared Chase state for enemies

func enter(_msg := {}) -> void:
	owner.play_animation("Run", "Animations")

func physics_update(_delta: float) -> void:
	if owner.health_manager.is_dead():
		state_machine.transition_to("Death")
		return
	
	
	var target = owner.get_target()
	if target == null && owner.last_target_position == null:
		state_machine.transition_to("Idle")
		return
	
	if (target != null && 
		owner.max_shooting_distance >= 
		(target.global_position - owner.global_position).length()):
		state_machine.transition_to("Attack")
		return

	if owner.nav_agent.can_update_path:
		var target_pos
		if target == null:
			target_pos = owner.last_target_position
		else:	
			target_pos = target.global_position
		owner.nav_agent.set_target_location(target_pos)
		owner.nav_agent.update_path_timer.start()
	
	
	if owner.nav_agent.is_navigation_finished():
		owner.nav_agent.can_update_path = true
		owner.forget_last_position()
		state_machine.transition_to("Idle")
		return
	
	
		
	var target_global_position = owner.nav_agent.get_next_location()
	var direction = owner.global_position.direction_to(target_global_position)
	owner.apply_internal_force(direction)
	owner.nav_agent.set_velocity(owner.internal_forces)
	
