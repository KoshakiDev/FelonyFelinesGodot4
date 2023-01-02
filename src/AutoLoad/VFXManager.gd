extends Node

const hit_effect = preload("res://src/components/effects/hit/HitEffect.tscn")
const dust_effect = preload("res://src/components/effects/dust_1/Dust.tscn")
const points_effect := preload("res://src/components/effects/point_effect/PointEffect.tscn")
const bullet_shell_effect := preload("res://src/components/effects/bullet_shell/BulletShell.tscn")

var new_effect = null

signal create_shockwave_effect

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
	instantiate_effect(points_effect)
	new_effect.init(points_amount)
	add_effect_to_world(effect_position)

func create_bullet_shell(effect_position):
	create_effect(bullet_shell_effect, effect_position)
