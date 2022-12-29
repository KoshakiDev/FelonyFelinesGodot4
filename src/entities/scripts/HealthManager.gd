extends Node

#HEALTH MANAGER
signal max_health_changed(new_max_health)
signal health_changed(new_health)
signal no_health

@export var max_health: float = 1 : set = set_max_health
@onready var health = max_health : set = set_health

@onready var regeneration_timer = $Regeneration

func set_max_health(new_max_health):
	max_health = new_max_health
	max_health = max(1, new_max_health)
	emit_signal("max_health_changed", max_health)

func set_health(new_value):
	health = new_value
	health = clamp(health, 0, max_health)
	emit_signal("health_changed", health)
	if is_dead():
		emit_signal("no_health")
	#natural_regen()


func natural_regen():
	if health >= max_health / 2 or !is_dead():
		regeneration_timer.stop()
	else:
		regeneration_timer.start()


func _on_Regeneration_timeout():
	heal(1)
	
func heal(heal_value):
	set_health(health + heal_value)

func take_damage(damage_value):
	set_health(health - damage_value)

func is_full_health():
	return health == max_health

func is_dead():
	return is_equal_approx(health, 0)

