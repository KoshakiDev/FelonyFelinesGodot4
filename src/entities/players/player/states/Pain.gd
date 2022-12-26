extends State

func _ready():
	owner.connect("pain", Callable(self, "pain"))

func pain(attack_direction, facing_direction):
	if ((attack_direction > 0 and facing_direction > 0) or 
			(attack_direction < 0 and facing_direction < 0)):
		state_machine.transition_to("Pain", {Back = true})
	elif ((attack_direction > 0 and facing_direction < 0) or 
			(attack_direction < 0 and facing_direction > 0)):
		state_machine.transition_to("Pain", {Front = true})


func enter(msg := {}) -> void:
	if msg.has("Front"):
		owner.play_animation("Hit_Front", "Movement")
	elif msg.has("Back"):
		owner.play_animation("Hit_Back", "Movement")
	await owner.animation_machine.get_node("Movement").animation_finished
	state_machine.transition_to("Idle")

