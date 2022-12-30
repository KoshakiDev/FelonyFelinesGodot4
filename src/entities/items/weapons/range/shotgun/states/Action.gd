extends State


# Unique Shotgun action state

func enter(_msg := {}) -> void:
	pass

func physics_update(_delta: float) -> void:
	if !owner.active:
		state_machine.transition_to("Disabled")
	if owner.is_out_of_ammo():
		state_machine.transition_to("Empty")
		return
	if Input.is_action_just_released("action" + owner.player_id):
		state_machine.transition_to("Idle")
	if Input.is_action_pressed("action" + owner.player_id):
		owner.shoot()
		
func exit():
	pass
