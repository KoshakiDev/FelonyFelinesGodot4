extends State

func enter(_msg := {}) -> void:
	await owner.animation_machine.find("AnimationPlayer").animation_finished
	owner.animation_machine.play_animation("Idle", "AnimationPlayer")
	#print("I am entering idle")
	
func physics_update(_delta: float) -> void:
	if !owner.active:
		state_machine.transition_to("Disabled")
	if Input.is_action_pressed("action" + owner.player_id):
		state_machine.transition_to("Action")
	#print("I am in idle")

func exit(_msg := {}) -> void:
	pass
