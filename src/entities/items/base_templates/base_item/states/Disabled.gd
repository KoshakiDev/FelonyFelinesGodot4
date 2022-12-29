extends State

func enter(_msg := {}) -> void:
	owner.animation_machine.play_animation("Idle", "AnimationPlayer")
	

func physics_update(_delta: float) -> void:
	pass

func exit():
	pass
