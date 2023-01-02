extends State
#Shared Idle state for Enemies

@onready var stand_timer = $StandTimer

func enter(_msg := {}) -> void:
	owner.play_animation("Idle", "Animations")
	stand_timer.start()

func physics_update(_delta: float) -> void:
	if owner.health_manager.is_dead():
		state_machine.transition_to("Death")
		return
	
	if owner.awareness_meter >= 0.3 || !stand_timer.is_stopped():
		target_detection()
	else:
		path_point_detection()

func path_point_detection():
	var path_point = owner.get_path_point()
	if path_point != null:
		state_machine.transition_to("Chase")
		return
	

func target_detection():
	var target = owner.get_target()
	if target != null:
		state_machine.transition_to("Attack")
		return
	if owner.last_target_position != null:
		state_machine.transition_to("Chase")
		return
	
