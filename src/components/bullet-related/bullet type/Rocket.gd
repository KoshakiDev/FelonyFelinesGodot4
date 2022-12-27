extends "res://src/components/bullet-related/bullet type/BaseProjectile.gd"

@export var EXPLOSION_SCENE: PackedScene

@onready var timer = $Timer

func _ready():
	super._ready()
	timer.connect("timeout", Callable(self, "timeout"))
	timer.start()

func timeout():
	explode()

func _on_Bullet_area_entered(_area):
	explode()

func explode():
	var boom: Area2D = EXPLOSION_SCENE.instantiate()
	boom.position = global_position
	Global.world.call_deferred("add_child", boom)
	queue_free()


func _on_Bullet_body_entered(_body):
	explode()
