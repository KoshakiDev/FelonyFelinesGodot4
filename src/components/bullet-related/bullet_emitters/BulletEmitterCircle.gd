class_name BulletEmitterCircle
extends BulletEmitter

# the amount of bullets shot in a spread
@export var amount := 24
# the angle between each of the bullets in degree

var spread_angle: float = 360


func shoot(bullet_instance: Projectile, bullet_scene : PackedScene):
	spread_shoot(bullet_instance, bullet_scene)
	#bullet_spawner_reference.queue_free()


func spread_shoot(bullet_instance : Projectile, bullet_scene : PackedScene):
	var directions = []
	var angle := deg_to_rad(spread_angle)
	var start_angle := 0.0
	#var start_angle := amount/2.0 * angle
	
	var sector_angle := angle / amount
	var saved_direction = bullet_instance.direction
	for i in range(amount):
		print(i)
		
		bullet_instance.direction = bullet_instance.direction.rotated(start_angle - sector_angle * i)
		shoot_single(bullet_instance, bullet_scene)
		bullet_instance.direction = saved_direction
