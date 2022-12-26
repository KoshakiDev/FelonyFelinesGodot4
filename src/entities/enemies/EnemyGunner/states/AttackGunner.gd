extends State

func enter(msg := {}) -> void:
	owner.play_animation("Idle", "Animations")

func exit() -> void:
	pass

func physics_update(_delta: float) -> void:
	if owner.health_manager.is_dead():
		state_machine.transition_to("Death")
		return
	var target = owner.get_target()
	if target == null:
		state_machine.transition_to("Idle")
		return
	owner.attack(target)
