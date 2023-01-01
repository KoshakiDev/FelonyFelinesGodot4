extends State
#Shared Idle state for Enemies


func enter(_msg := {}) -> void:
	owner.play_animation("Idle", "Animations")

func physics_update(_delta: float) -> void:
	if owner.health_manager.is_dead():
		state_machine.transition_to("Death")
		return
	if owner.awareness_meter < 0.3:
		return
	var target = owner.get_target()
	if target != null:
		state_machine.transition_to("Attack")
		return
	
	if owner.last_target_position != null:
		state_machine.transition_to("Chase")
		return
	
	
