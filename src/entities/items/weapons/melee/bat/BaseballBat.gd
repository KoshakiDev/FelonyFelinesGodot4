extends "res://src/entities/items/base_templates/base_melee_weapon/BaseMeleeWeapon.gd"

var hit_counter 
@export var hit_maximum = 50


# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	hitbox.connect("area_entered", Callable(self, "add_hit_count"))


func add_hit_count():
	hit_counter += 1
	if hit_counter >= hit_maximum:
		sound_machine.play_sound("Break")
		queue_free()
