extends Node2D

@onready var items_container = self

@onready var items = items_container.get_children()

var max_slot_size = 5
var item_slots_size = 1
var cur_slot = 0
var cur_item = null

var item_owner: Node2D
var player_id = ""

var ammo_bar: Node2D

func _ready():
	if items.size() != 0:
		switch_to_item_slot(cur_slot)

func _input(event):
	if event.is_action_pressed("next_weapon" + player_id):
		switch_to_next_item()
	if event.is_action_pressed("prev_weapon" + player_id):
		switch_to_prev_item()
		
		
func init(set_item_owner: Node2D, set_ammo_bar: Node2D) -> void:
	self.item_owner = set_item_owner
	self.ammo_bar = set_ammo_bar
	if item_owner.get("player_id") != null:
		player_id = item_owner.player_id
	for item in items:
		item.init(item_owner)

func return_ammo_count():
	if cur_item == null:
		return -1
	if cur_item.get("ammo") != null:
		return cur_item.ammo
	else:
		return -1

func add_item(new_item):
	new_item.cancel_despawn()
	check_duplicant(new_item)
	new_item.position = Vector2.ZERO
	new_item.connect("switch_to_next_item", Callable(self, "switch_to_next_item"))
	new_item.connect("switch_to_prev_item", Callable(self, "switch_to_prev_item"))
	
	#print("adding item")
	
	if new_item.has_method("init"):
		new_item.init(item_owner)
	Global.reparent(new_item, items_container)
	await new_item.tree_entered
	update_children()
	#print(items)

func get_duplicant(new_item):
	for item in items:
		if new_item.entity_name == item.entity_name:
			return item
	return null
	
func check_duplicant(new_item):
	if is_duplicant(new_item):
		# TODO: increase amount of click allowed
		var dupe_item = get_duplicant(new_item)
		if dupe_item.item_type == "RANGE" or dupe_item.item_type == "MEDKIT":
			dupe_item.add_ammo_pack()
			owner.ammo_bar.update_ammo_bar(return_ammo_count())
	if is_duplicant(new_item):
		#print("is duplicant")
		new_item.queue_free()
		return
	

func is_duplicant(new_item):
	var dupe_item = get_duplicant(new_item)
	return dupe_item != null


func switch_to_next_item():
	update_children()
	
	if item_slots_size == 0:
		return
	
	cur_slot = posmod((cur_slot + 1), item_slots_size)
	
	switch_to_item_slot(cur_slot)

func switch_to_prev_item():
	update_children()
	
	if item_slots_size == 0:
		return
	
	cur_slot = posmod((cur_slot - 1), item_slots_size)
	switch_to_item_slot(cur_slot)


func switch_to_item_slot(slot_ind: int):
	if slot_ind < 0 or slot_ind >= item_slots_size:
		return
	disable_all_items()
	cur_item = items[slot_ind]
	
	cur_item.set_active()
	
	if cur_item.has_signal("ammo_changed"):
		cur_item.connect("ammo_changed",Callable(ammo_bar,"update_ammo_bar"))
		cur_item.emit_signal("ammo_changed", return_ammo_count())
	

func disable_all_items():
	for item in items:
		item.set_inactive()
		if item.has_signal("ammo_changed"):
			if item.is_connected("ammo_changed", Callable(ammo_bar,"update_ammo_bar")):
				item.disconnect("ammo_changed",Callable(ammo_bar,"update_ammo_bar"))
	

func update_children():
	items = items_container.get_children()
	item_slots_size = items.size()
	cur_item = null
	switch_to_item_slot(cur_slot)
