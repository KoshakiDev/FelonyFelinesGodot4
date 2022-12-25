extends Area2D

@onready var collision_shape = $HurtboxShape

const empty_bitmask = 0b00000000000000000000

func _ready():
	if collision_layer == empty_bitmask && collision_mask == empty_bitmask:
		print("WARNING: Hurtbox has no layer and mask!")


func turn_off():
	monitorable = false
	monitoring = false
	
func turn_on():
	monitorable = false
	monitoring = false
