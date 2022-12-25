class_name BulletEmitterSingle
extends BulletEmitter

# The spread of the bullets in degree
@export var spread := 10

func shoot(bullet_instance: Projectile, bullet_scene : PackedScene):
	bullet_instance.direction = bullet_instance.direction.rotated(deg_to_rad(randf_range(-spread, spread)))
	shoot_single(bullet_instance, bullet_scene)
