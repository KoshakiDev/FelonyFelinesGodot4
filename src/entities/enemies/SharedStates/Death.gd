extends State

#Shared Death state for Enemies


func enter(_msg := {}) -> void:
	owner.turn_off_all()
	owner.sound_machine.play_sound("Death")
	owner.play_animation("Death", "Animations")
	
	var points_amount = 1
	owner.emit_signal("points_effect", owner.global_position, points_amount)
	
	#update_points()

func update_points() -> void:
	pass
	#owner.emit_signal("update_points", points_amount)


func enemy_drop():
	# drop is a number between 0 and 99
	var drop = randi() % 100

	# if drop is strictly less than our percentage, then drop something
	if drop < owner.ITEM_DROP_PERCENT:
		var drop_list = []
		for key in Global.ITEM_DROP_WEIGHTS:
			for _i in range(Global.ITEM_DROP_WEIGHTS[key]):
				drop_list.append(key)

		# index is a number between 0 and list size - 1
		var index = randi() % drop_list.size()
		# load the scene at index
		var scene = str("res://src/entities/items/", drop_list[index], ".tscn")
		
		#print(scene)
		
		instance_scene(load(scene).instantiate())

func instance_scene(instance):
	instance.global_position = owner.global_position
	Global.world.add_child(instance)


func delete_enemy():
	enemy_drop()
	#print("1")
	if Global.main == null or Global.UI_layer == null:
		owner.queue_free()
		return
	Global.enemy_count = Global.enemy_count - 1
	if Global.enemy_count == 0:
		Global.main.update_wave()
	
	#Global.main.update_board()
	#Global.UI_layer.update_board()
	owner.queue_free()
