extends "res://src/entities/base_templates/base_npc/base_npc.gd"

@onready var handgun = $Visuals/Sprite2D/HandGun
@onready var bullet_spawner = $Visuals/Sprite2D/HandGun/BulletSpawner

func _ready():
	super._ready()
	bullet_spawner.connect("shot_fired",Callable(self,"shot_fired"))


func attack(target):
	var look_dir = (target.global_position - global_position).normalized()
	if look_dir.x < 0:
		visuals.scale.x = -1
	else:
		visuals.scale.x = 1
	
	if visuals.scale.x == -1:
		handgun.rotation = PI - (target.global_position - global_position).angle()
	elif visuals.scale.x == 1:
		handgun.rotation = (target.global_position - global_position).angle()
	bullet_spawner.shoot()

var recoil = 10

func shot_fired():
	apply_external_force(-1 * internal_forces, recoil) 
	sound_machine.play_sound("Attack")
