extends Area2D


@onready var collision_shape = $HitboxShape

@export var hitbox_data: HitboxData


@export_group("Damage Variables")
@export var damage_value: float = 1
@export var knockback_value: float  = 1

var hitbox_owner = null
# To-do: merge bullet_owner and hitbox_owner

const empty_bitmask = 0b00000000000000000000

func _ready():
	if collision_layer == empty_bitmask && collision_mask == empty_bitmask:
		print("WARNING: Hitbox has no layer and mask!")

func turn_off():
	monitorable = false
	monitoring = false
	
func turn_on():
	monitorable = true
	monitoring = true

func get_hitbox_data() -> HitboxData: 
	return hitbox_data
