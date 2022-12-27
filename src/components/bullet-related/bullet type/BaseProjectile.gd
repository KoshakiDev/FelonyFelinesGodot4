extends "res://src/components/hitbox-hurtbox/hitbox/Hitbox.gd"
class_name Projectile


const MAX_DISTANCE := 2000

# Internal state

# global_position
var direction: Vector2 = Vector2.RIGHT
var speed: float = 1.0
# damage_value
# knockback_value

@onready var start_position := global_position

signal dust_effect(effect_position)

func _ready() -> void:
	super._ready()
	connect("dust_effect", Callable(VFXManager, "create_dust_effect"))
	connect("area_entered",Callable(self,"_on_Bullet_area_entered"))
	connect("body_entered",Callable(self,"_on_Bullet_body_entered"))

func setup(
		set_bullet_position,
		set_direction, 
		set_speed, 
		set_damage_value, 
		set_knockback_value) -> void:
	global_position = set_bullet_position
	direction = set_direction
	speed = set_speed
	damage_value = set_damage_value
	knockback_value = set_knockback_value
	rotation = (direction - Vector2.ZERO).angle()
	
	
func _physics_process(delta: float) -> void:
	position += direction * speed * delta
	if start_position.distance_to(global_position) > MAX_DISTANCE:
		queue_free()

func _on_Bullet_area_entered(_area):
	emit_signal("dust_effect", global_position)
	queue_free()

func _on_Bullet_body_entered(_body):
	emit_signal("dust_effect", global_position)
	queue_free()
