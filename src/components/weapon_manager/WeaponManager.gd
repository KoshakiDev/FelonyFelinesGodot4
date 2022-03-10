extends Node2D

onready var weapons_container = self

onready var weapons = weapons_container.get_children()

var max_slot_size = 5
var weapon_slots_size = 1
var cur_slot = 0
var cur_weapon = null

func _ready():
	if weapons.size() != 0:
		switch_to_weapon_slot(cur_slot)

func add_weapon(new_weapon):
	new_weapon.cancel_despawn()
	if is_duplicant(new_weapon) and new_weapon.entity_name != "MEDKIT" and new_weapon.entity_name != "AMMO":
		print("is duplicant")
		new_weapon.queue_free()
		return
	new_weapon.in_inventory = true
	new_weapon.despawnable = false
	new_weapon.position = Vector2.ZERO
	Global.reparent(new_weapon, weapons_container)
	update_children()

func is_duplicant(new_weapon):
	if weapons.size() == 0:
		return false
	#print(weapons.size())
	#print(new_weapon, new_weapon.entity_name)
	for weapon in weapons:
		if new_weapon.entity_name == weapon.entity_name:
			return true
	return false

func switch_to_next_weapon():
	cur_slot = (cur_slot + 1) % weapon_slots_size
	switch_to_weapon_slot(cur_slot)

func switch_to_prev_weapon():
	cur_slot = posmod((cur_slot - 1), weapon_slots_size)
	switch_to_weapon_slot(cur_slot)

func switch_to_weapon_slot(slot_ind: int):
	if slot_ind < 0 or slot_ind >= weapon_slots_size:
		return
	disable_all_weapons()
	cur_weapon = weapons[slot_ind]
	if cur_weapon.has_method("set_active"):
		cur_weapon.set_active()
	else:
		cur_weapon.visible = true

func disable_all_weapons():
	for weapon in weapons:
		if weapon.has_method("set_inactive"):
			weapon.set_inactive()
		else:
			weapon.visible = false

func update_children():
	weapons = weapons_container.get_children()
	weapon_slots_size = weapons.size()

	switch_to_weapon_slot(cur_slot)