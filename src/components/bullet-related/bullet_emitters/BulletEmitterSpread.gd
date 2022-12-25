class_name BulletEmitterSpread
extends BulletEmitter

# the amount of bullets shot in a spread
@export var amount := 3
# the angle between each of the bullets in degree
@export var spread_angle: float = 5

func shoot(bullet_instance: Projectile, bullet_scene : PackedScene):
	spread_shoot(bullet_instance, bullet_scene)


func spread_shoot(bullet_instance : Projectile, bullet_scene : PackedScene):
	var directions = []
	var angle := deg_to_rad(spread_angle)
	var start_angle := amount/2.0 * angle
	
	var saved_direction = bullet_instance.direction
	for i in range(amount):
		bullet_instance.direction = bullet_instance.direction.rotated(start_angle - angle * i)
		shoot_single(bullet_instance, bullet_scene)
		bullet_instance.direction = saved_direction
