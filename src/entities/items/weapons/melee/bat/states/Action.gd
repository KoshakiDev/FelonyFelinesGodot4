extends State


#Melee Weapon Shooting State

func enter(_msg := {}) -> void:
	owner.action()
		

func physics_update(_delta: float) -> void:
	if Input.is_action_just_released("action" + owner.player_id):
		state_machine.transition_to("Idle")
	if Input.is_action_pressed("action" + owner.player_id):
		owner.action()

func exit():
	pass
