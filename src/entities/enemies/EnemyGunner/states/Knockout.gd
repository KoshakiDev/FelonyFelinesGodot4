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
	owner.turn_off_all()
	owner.forget_last_position()
	owner.play_animation("Knockout", "Animations")
	if owner.has_gun():
		owner.emit_signal("drop_specific_weapon", owner.global_position, owner.item_holder.gun.entity_name)
		owner.item_holder.delete_gun()
	knockout_timer.visible = true
	knockout_timer.start()
	

func physics_update(_delta: float) -> void:
	pass

func timeout():
	knockout_timer.visible = false
	owner.turn_on_all()
	owner.health_manager.heal(owner.health_manager.max_health)
	state_machine.transition_to("Idle")
	
