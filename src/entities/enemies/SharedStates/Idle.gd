extends State
#Shared Idle state for Enemies

@onready var stand_timer = $StandTimer

func enter(_msg := {}) -> void:
	owner.play_animation("Idle", "Animations")
	stand_timer.start()
	owner.update_internal_force_timer.start()

func exit() -> void:
	owner.update_internal_force_timer.stop()

func physics_update(_delta: float) -> void:
	if check_death():
		return
	
	if owner.last_target_position != null:
		owner.forget_all_path_points()
		state_machine.transition_to("Chase")
		return
	
	if owner.awareness_meter >= 0.3 || !stand_timer.is_stopped():
		if check_target_detection():
			return
	else:
		if check_path_point_detection():
			return

func check_death():
	if owner.health_manager.is_dead():
		state_machine.transition_to("Death")
		return true
	

func check_path_point_detection():
	var path_point = owner.get_path_point()
	if path_point != null:
		state_machine.transition_to("Chase")
		return true
	

func check_target_detection():
	var target = owner.get_target()
	if target != null:
		owner.forget_all_path_points()
		stand_timer.stop()
		state_machine.transition_to("Attack")
		return true
