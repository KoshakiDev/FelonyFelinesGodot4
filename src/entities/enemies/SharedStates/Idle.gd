extends State
#Shared Idle state for Enemies

@onready var stand_timer = $StandTimer

var transition_to_state = "Idle"

func enter(_msg := {}) -> void:
	owner.play_animation("Idle", "Animations")
	stand_timer.start()
	owner.update_internal_force_timer.start()
	

func exit() -> void:
	stand_timer.stop()
	owner.update_internal_force_timer.stop()

func physics_update(_delta: float) -> void:
	if check_death():
		return
	if check_path_point_detection() || check_target_detection():
		state_machine.transition_to(transition_to_state)
		return

func check_death():
	if owner.health_manager.is_dead():
		state_machine.transition_to("Death")
		return true

func check_path_point_detection():
	if owner.is_stationary:
		return false
	if owner.awareness_meter >= 0.3:
		return false
	if !stand_timer.is_stopped():
		return false
	
	var path_point = owner.get_path_point()
	if path_point == null:
		return false
	else:
		transition_to_state = "Chase"
		return true
	
	
func check_target_detection():
	var target = owner.get_target()
	
	if (target != null && 
		owner.awareness_meter >= 0.8):
		owner.forget_all_path_points()
		stand_timer.stop()
		transition_to_state = "Attack"
		return true
	
	if owner.is_stationary:
		return false
	
	if owner.last_target_position != null:
		owner.forget_all_path_points()
		transition_to_state = "Chase"
		return true
	return false
