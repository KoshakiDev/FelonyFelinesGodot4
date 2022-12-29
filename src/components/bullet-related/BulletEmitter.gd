class_name BulletEmitter
extends Resource

var bullet_spawner_reference: BulletSpawner
	
func shoot(_bullet_instance : Projectile, _bullet_scene : PackedScene):
	pass

func shoot_single(bullet_instance : Projectile, bullet_scene : PackedScene):
	var new_bullet = bullet_scene.instantiate()
	
	new_bullet.setup(
		bullet_instance.global_position,
		bullet_instance.direction, 
		bullet_instance.speed, 
		bullet_instance.damage_value, 
		bullet_instance.knockback_value,
		bullet_instance.can_hit_enemies,
		bullet_instance.can_hit_players,
		)
	
	Global.world.call_deferred("add_child", new_bullet)
	#Global.world.add_child(new_bullet)
