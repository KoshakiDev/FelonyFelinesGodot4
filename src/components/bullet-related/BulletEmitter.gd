class_name BulletEmitter
extends Resource

	
func shoot(_bullet_instance : Projectile, bullet_scene : PackedScene):
	pass

func shoot_single(bullet_instance : Projectile, bullet_scene : PackedScene):
	var new_bullet = bullet_scene.instantiate()
	
	new_bullet.setup(
		bullet_instance.global_position,
		bullet_instance.direction, 
		bullet_instance.speed, 
		bullet_instance.damage_value, 
		bullet_instance.knockback_value)
	
	
	Global.world.add_child(new_bullet)
