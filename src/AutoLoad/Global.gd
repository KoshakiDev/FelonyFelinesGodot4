extends Node

@onready var FRICTION = 0.1
@onready var ACCEL = 0.1

var ROTATION_SPEED = PI / 45


const empty_bitmask = 0b00000000000000000000


var world
var main
var root
var UI_layer

var final_score
var wave_survived

var alert_counter = 0

var points = 0
var wave_num = 0
var enemy_count = 0

var ITEM_DROP_WEIGHTS = {
	"weapons/melee/axe/Axe": 4,
	"weapons/melee/bat/BaseballBat": 4,
	"weapons/range/shotgun/Shotgun": 3,
	"medkit/Medkit": 5,
	"weapons/range/minigun/Minigun": 1,
	"weapons/range/revolver/Revolver": 5,
	"weapons/range/rocket_launcher/RocketLauncher": 1
}

var ITEM_NAME_TO_PATH = {
	"AXE": "weapons/melee/axe/Axe",
	"SHOTGUN": "weapons/range/shotgun/Shotgun",
	"MEDKIT": "medkit/Medkit",
	"MINIGUN": "weapons/range/minigun/Minigun",
	"REVOLVER": "weapons/range/revolver/Revolver",
	"RPG": "weapons/range/rocket_launcher/RocketLauncher"
}

signal all_dead
signal update_alert_count

func _ready():
	enemy_count = 0
	wave_num = 0
	points = 0
	root = get_parent()
	normalize_item_drop_weights()


func frame_freeze(time_scale, duration):
	Engine.time_scale = time_scale
	await get_tree().create_timer(duration * time_scale).timeout
	Engine.time_scale = 1.0

#func player_died():
#	var counter = 0
#	for player in players.get_children():
#		if player.health_manager.is_dead():
#			counter += 1
#	if counter == 2:
#		for player in players.get_children():
#			player.respawn_radius.deactivate_respawn_radius()
#		emit_signal("all_dead")

func reparent(child: Node, new_parent: Node):
	var old_parent = child.get_parent()
	old_parent.remove_child(child)
	new_parent.call_deferred("add_child", child)
#	new_parent.add_child(child)
	child.set_deferred("owner", new_parent.owner)

func random_vector2(n):
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	return Vector2(rng.randf_range(-n, n), rng.randf_range(-n, n))

func drop_specific_weapon(drop_position, weapon_name):
	var scene = str("res://src/entities/items/", ITEM_NAME_TO_PATH[weapon_name], ".tscn")
	instance_scene(load(scene), drop_position)



func drop_weapon(drop_position, ITEM_DROP_PERCENT):
	# drop is a number between 0 and 99
	var drop = randi() % 100
	# if drop is strictly less than our percentage, then drop something
	if drop < ITEM_DROP_PERCENT:
		var drop_list = []
		for key in ITEM_DROP_WEIGHTS:
			for _i in range(ITEM_DROP_WEIGHTS[key]):
				drop_list.append(key)

		# index is a number between 0 and list size - 1
		var index = randi() % drop_list.size()
		# load the scene at index
		var scene = str("res://src/entities/items/", drop_list[index], ".tscn")
		
		instance_scene(load(scene), drop_position)


func instance_scene(_instance_scene, instance_position):
	var new_instance = _instance_scene.instantiate()
	new_instance.global_position = instance_position
	Global.world.call_deferred("add_child", new_instance)


func update_board():
	enemy_count -= 1
	if enemy_count == 0:
		main.update_wave()
	#main.update_board()
	#UI_layer.update_board()

#func get_all_enemies():
#	var enemies_result = {
#		"BALL":[],
#		"GUNNER":[],
#		"IMP": []
#	}
#
#	var enemy_names = enemies_result.keys()
#	for entity in enemies.get_children():
#		if not entity.is_in_group("ENTITY"):
#			continue
#		if entity.entity_name in enemy_names:
#			enemies_result[entity.entity_name].append(entity)
#	#print(enemies_result)
#	return enemies_result

func normalize_item_drop_weights():
	var sum = 0
	# force multiplier to be a float
	var multiplier = 1.0
	for key in ITEM_DROP_WEIGHTS:
		sum += round(ITEM_DROP_WEIGHTS[key])
	# if our sum is greater than 100 then we want then find the
	# multiplier that will bring it close to 100
	if sum > 100:
		multiplier = 100/sum

	for key in ITEM_DROP_WEIGHTS:
		# First do the multiplier
		ITEM_DROP_WEIGHTS[key] = multiplier * float(ITEM_DROP_WEIGHTS[key])
		# if rounding it will make it zero (i.e. it was .4) then make it 1
		if ITEM_DROP_WEIGHTS[key] > 0 && round(ITEM_DROP_WEIGHTS[key]) == 0:
			ITEM_DROP_WEIGHTS[key] = 1
		else:
			ITEM_DROP_WEIGHTS[key] = round(ITEM_DROP_WEIGHTS[key])


#func get_closest_enemy(position: Vector2):
#	var closest_enemy: CharacterBody2D
#	var closest_distance = 999999999
#
#	for enemy in enemies.get_children():
#		var distance = (position - enemy.global_position).length()
#		if distance < closest_distance:
#			closest_enemy = enemy
#			closest_distance = distance
#
#	return closest_enemy

#func get_brother():
#	for player in players.get_children():
#		if player.entity_type == "PLAYER":
#			return player
#		#if not player.is_in_group("PLAYER"): continue
#	#for player in entity_world.get_children():

#func get_closest_player(position: Vector2):
#	var closest_player: CharacterBody2D
#	var closest_distance = 999999999
#
#
#	for player in players.get_children():
#		if player.health_manager.is_dead(): continue
#
#		var distance = (position - player.global_position).length()
#		if distance < closest_distance:
#			closest_player = player
#			closest_distance = distance
#
#	return closest_player

#func get_farthest_player(position: Vector2):
#	var farthest_player: CharacterBody2D
#	var farthest_distance = 0
#
#	for player in players.get_children():
#		if player.health_manager.is_dead(): continue
#
#		var distance = (position - player.global_position).length()
#		if distance > farthest_distance:
#			farthest_player = player
#			farthest_distance = distance
#
#	return farthest_player
