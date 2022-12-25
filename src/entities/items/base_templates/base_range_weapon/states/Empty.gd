extends State

func enter(_msg := {}) -> void:
	owner.sound_machine.play_sound("Empty")
	state_machine.transition_to("Idle")
	

func exit():
	pass
