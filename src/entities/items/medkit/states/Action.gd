extends State


func enter(_msg := {}) -> void:
	pass
	#owner.animation_machine.play_animation("Idle", "AnimationPlayer")
	#print("I am entering idle")

func physics_update(_delta: float) -> void:
	if owner.is_out_of_ammo():
		state_machine.transition_to("Idle")
		return
	if Input.is_action_just_released("action" + owner.player_id):
		state_machine.transition_to("Idle")
	
	if Input.is_action_pressed("action" + owner.player_id):
		owner.action()

func exit(_msg := {}) -> void:
	pass
