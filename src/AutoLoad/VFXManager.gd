extends Node

const hit_effect = preload("res://src/components/hit/HitEffect.tscn")
const dust_effect = preload("res://src/components/dust_spawner/dust_types/player/Dust.tscn")
const points_effect := preload("res://src/ScreenEffects/PointEffect.tscn")

var new_effect = null

func create_effect(effect_instance, effect_position):
	instantiate_effect(effect_instance)
	add_effect_to_world(effect_position)
	
func instantiate_effect(effect_instance):
	new_effect = effect_instance.instantiate()

func add_effect_to_world(effect_position):
	Global.world.add_child(new_effect)
	new_effect.global_position = effect_position

func create_hit_effect(effect_position):
	create_effect(hit_effect, effect_position)

func create_dust_effect(effect_position):
	create_effect(dust_effect, effect_position)

func create_points_effect(effect_position, points_amount):
	print("points created")
	instantiate_effect(points_effect)
	new_effect.init(points_amount)
	add_effect_to_world(effect_position)
	#create_effect(points_effect, effect_position)
	
