extends "res://src/entities/items/base_templates/base_range_weapon/BaseRangeWeapon.gd"


func shot_fired():
	super.shot_fired()
	emit_signal("bullet_shell_effect", sprite.global_position)

