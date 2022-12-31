extends "res://src/entities/items/base_templates/base_item/base_item.gd"


@export_group("Medkit Settings")
@export var heal_value = 20
@export var ammo = 1
@onready var ammo_pack_amount = 1

signal ammo_changed(new_ammo)


func _ready():
	pass
	#animation_machine.play_animation("Idle", "AnimationPlayer")

func add_ammo_pack() -> void:
	ammo = ammo + ammo_pack_amount
	emit_signal("ammo_changed", ammo)
	return

func is_out_of_ammo() -> bool:
	return ammo <= 0

func reduce_ammo() -> void:
	ammo = max(ammo - 1, 0)
	emit_signal("ammo_changed", ammo)

func action() -> void:
	if item_owner.health_manager.is_full_health():
		return
	item_owner.health_manager.heal(heal_value)
	reduce_ammo()
	sound_machine.play_sound("Eat")
