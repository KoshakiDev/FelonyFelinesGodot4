extends Node

const hit_effect = preload("res://src/components/hit/HitEffect.tscn")
const dust_effect = preload("res://src/components/dust_spawner/dust_types/player/Dust.tscn")

func create_effect(effect_instance, effect_position):
	var new_effect = effect_instance.instantiate()
	Global.world.add_child(new_effect)
	new_effect.global_position = effect_position

func create_hit_effect(effect_position):
	create_effect(hit_effect, effect_position)

func create_dust_effect(effect_position):
	create_effect(dust_effect, effect_position)

