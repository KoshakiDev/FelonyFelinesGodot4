extends State

#Shared Chase state for enemies

var next_position = null

func enter(_msg := {}) -> void:
	owner.play_animation("Run", "Animations")

func physics_update(_delta: float) -> void:
	next_position = null
	
	if check_death():
		return
	
	if owner.awareness_meter < 0.3:
		if check_path_point_detection():
			return
	else:
		if check_target_detection():
			return
	
	if owner.nav_agent.can_update_path:
		owner.nav_agent.set_target_location(next_position)
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

func check_death():
	if owner.health_manager.is_dead():
		state_machine.transition_to("Death")
		return true
	
func check_path_point_detection():
	var path_point = owner.get_path_point()
	if path_point == null:
		state_machine.transition_to("Idle")
		return true
	next_position = path_point.global_position + owner.get_normalized_internal_forces_direction() * 25
	
func check_target_detection():
	var target = owner.get_target()
	if target == null && owner.last_target_position == null:
		state_machine.transition_to("Idle")
		return true
	
	if (target != null && 
		owner.max_shooting_distance >= 
		(target.global_position - owner.global_position).length()):
		state_machine.transition_to("Attack")
		return true
		
	if target == null:
		next_position = owner.last_target_position
	else:
		next_position = target.global_position
