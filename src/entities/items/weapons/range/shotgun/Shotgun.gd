extends "res://src/entities/items/base_templates/base_range_weapon/BaseRangeWeapon.gd"


func shot_fired():
	super.shot_fired()

	await animation_machine.find("AnimationPlayer").animation_finished
	
	for i in range(bullet_spawner.bullet_emitter.amount):
		emit_signal("bullet_shell_effect", sprite.global_position)
	
	animation_machine.play_animation("Click", "AnimationPlayer")
	await animation_machine.find("AnimationPlayer").animation_finished
	
	
