extends State

# Knockout State

@export var knockout_timer: Node2D
@export var wait_time: float = 1.0

func _ready():
	knockout_timer._ready()
	knockout_timer.visible = false
	knockout_timer.setup_timer(wait_time)
	knockout_timer.reset_progress()
	knockout_timer.connect("timeout", Callable(self, "timeout"))

func enter(_msg := {}) -> void:
	knockout_timer.visible = true
	knockout_timer.start()
	owner.turn_off_all()
	owner.play_animation("Knockout", "Animations")
	

func physics_update(_delta: float) -> void:
	if owner.health_manager.is_dead():
		state_machine.transition_to("Death")
		return

func timeout():
	knockout_timer.visible = false
	owner.turn_on_all()
	state_machine.transition_to("Idle")
	
