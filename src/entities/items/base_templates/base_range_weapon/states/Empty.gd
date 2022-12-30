extends State

func enter(_msg := {}) -> void:
	owner.sound_machine.play_sound("Empty")
	state_machine.transition_to("Idle")

func _physics_process(_delta):
	if !owner.active:
		state_machine.transition_to("Disabled")
	

func exit():
	pass
