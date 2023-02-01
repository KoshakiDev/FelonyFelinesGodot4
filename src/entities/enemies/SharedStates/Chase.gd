extends State

#Shared Chase state for enemies

var next_position = null
var transition_to_state = "Idle"

@onready var chase_timer = $ChaseTimer

func enter(_msg := {}) -> void:
	owner.play_animation("Run", "Animations")
	chase_timer.start()

func physics_update(_delta: float) -> void:
	next_position = null
	
	if check_death():
		return
	
	if check_path_point_detection() && check_target_detection():
		state_machine.transition_to(transition_to_state)
		return
	
	if chase_timer.is_stopped():
		owner.forget_last_position()
		owner.forget_all_path_points()
		state_machine.transition_to("Idle")
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
	if owner.awareness_meter >= 0.3:
		return true
	var path_point = owner.get_path_point()
	
	if path_point == null:
		transition_to_state = "Idle"
		return true
	else:
		next_position = path_point.global_position
		return false
	
func check_target_detection():
	var target = owner.get_target()
	if target == null && owner.last_target_position == null:
		transition_to_state = "Idle"
		return true
	
	if (target != null && 
		owner.max_shooting_distance >= 
		(target.global_position - owner.global_position).length() && 
		owner.awareness_meter >= 0.8):
		transition_to_state = "Attack"
		return true
		
	if target == null:
		next_position = owner.last_target_position
	else:
		next_position = target.global_position
	return false
