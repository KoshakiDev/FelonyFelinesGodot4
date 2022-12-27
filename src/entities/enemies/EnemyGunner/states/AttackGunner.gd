extends State

func enter(_msg := {}) -> void:
	owner.play_animation("Idle", "Animations")

func exit() -> void:
	pass

func physics_update(_delta: float) -> void:
	if owner.health_manager.is_dead():
		state_machine.transition_to("Death")
		return
	var target = owner.get_target()
	if target == null && owner.last_target_position == null:
		state_machine.transition_to("Idle")
		return
	elif target == null && owner.last_target_position != null:
		state_machine.transition_to("Chase")
		return
	
	owner.attack(target)
