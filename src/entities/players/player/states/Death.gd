extends State

func enter(_msg := {}) -> void:
	owner.turn_off_all()
	owner.play_animation("Death", "Movement")
	await owner.animation_machine.get_node("Movement").animation_finished
