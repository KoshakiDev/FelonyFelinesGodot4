extends "res://src/entities/items/base_templates/base_range_weapon/BaseRangeWeapon.gd"

func _ready():
	# !Intentionally not calling parent ready function!
	bullet_spawner.connect("shot_fired",Callable(self,"shot_fired"))
	
func shot_fired() -> void:
	animation_machine.play_animation("Shoot", "AnimationPlayer")
	if item_owner.has_method("apply_external_force"):
		item_owner.apply_external_force(-1 * item_owner.internal_forces, recoil) 
	sound_machine.play_sound("Shot")
