extends State

var counter = 0;

func enter(_msg := {}) -> void:
	owner.animation_machine.play_animation("Idle", "AnimationPlayer")
	#print("I am entering idle")

func handle_input(_event: InputEvent) -> void:
	pass
	
func physics_update(_delta: float) -> void:
	if Input.is_action_pressed("action" + owner.player_id):
		state_machine.transition_to("Action")
	#print("I am in idle")

func exit(_msg := {}) -> void:
	pass