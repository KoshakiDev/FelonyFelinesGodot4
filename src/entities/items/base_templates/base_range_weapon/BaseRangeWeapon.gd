extends "res://src/entities/items/base_templates/base_item/base_item.gd"

signal ammo_changed(new_ammo)

@export_group("Weapon Stats")
@export var ammo = 10
@export var recoil = 50
@export var ammo_pack_amount = 5

@onready var bullet_spawner = $Marker2D/Visuals/Sprite2D/BulletSpawner

func _ready() -> void:
	super._ready()
	bullet_spawner.can_hit_enemies = true
	bullet_spawner.can_hit_players = false
	bullet_spawner.connect("shot_fired",Callable(self,"shot_fired"))
	#print(bullet_spawner)

func shoot():
	bullet_spawner.shoot()

func add_ammo_pack() -> void:
	ammo = ammo + ammo_pack_amount
	emit_signal("ammo_changed", ammo)
	return

func is_empty():
	super.is_empty()
	return is_out_of_ammo()

func is_out_of_ammo() -> bool:
	return ammo <= 0

func reduce_ammo() -> void:
	ammo = max(ammo - 1, 0)
	emit_signal("ammo_changed", ammo)

func shot_fired() -> void:
	animation_machine.play_animation("Shoot", "AnimationPlayer")
	if item_owner.has_method("apply_external_force"):
		item_owner.apply_external_force(-1 * item_owner.internal_forces, recoil) 
	reduce_ammo()
	sound_machine.play_sound("Shot")
	Shake.shake(2.5, .5)
	
