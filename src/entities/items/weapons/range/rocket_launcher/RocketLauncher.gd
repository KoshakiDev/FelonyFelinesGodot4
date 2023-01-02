extends "res://src/entities/items/base_templates/base_range_weapon/BaseRangeWeapon.gd"


func _ready():
	super._ready()
	bullet_spawner.can_hit_enemies = true
	bullet_spawner.can_hit_players = true
