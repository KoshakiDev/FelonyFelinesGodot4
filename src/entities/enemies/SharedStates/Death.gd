extends State

#Shared Death state for Enemies


func enter(_msg := {}) -> void:
#	if owner.burglar_mode:
#		state_machine.transition_to("Knockout")
#		return
	owner.turn_off_all()
	owner.sound_machine.play_sound("Death")
	owner.play_animation("Death", "Animations")
	
	
	var points_amount = 1
	owner.emit_signal("points_effect", owner.global_position, 
		points_amount)
	
#	if owner.has_gun():
#		if !owner.has_signal("drop_specific_weapon"):
#			owner.emit_signal("drop_weapon", owner.global_position, 
#				owner.ITEM_DROP_PERCENT)
#		else:
#			owner.emit_signal("drop_specific_weapon", owner.global_position, owner.item_holder.gun.entity_name)
#	#owner.emit_signal("update_board")
	#owner.emit_signal("update_points", points_amount)


func delete_enemy():
	owner.queue_free()
