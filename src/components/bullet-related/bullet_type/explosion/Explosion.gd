extends "res://src/components/hitbox-hurtbox/hitbox/Hitbox.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

@onready var bullet_spawner = $BulletSpawner

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("Explode")
	bullet_spawner.can_hit_players = true
	bullet_spawner.can_hit_enemies = true
	bullet_spawner.shoot()
