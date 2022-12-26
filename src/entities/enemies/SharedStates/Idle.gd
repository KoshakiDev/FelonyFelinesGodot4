extends State
#Shared Idle state for Enemies


func enter(msg := {}) -> void:
	owner.play_animation("Idle", "Animations")

func physics_update(delta: float) -> void:
	if owner.health_manager.is_dead():
		state_machine.transition_to("Death")
		return
	
	var target = owner.get_target()
	if target != null:
		state_machine.transition_to("Attack")
		return
	
