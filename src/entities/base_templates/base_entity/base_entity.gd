#BASE CLASS FOR ALL ENTITIES
extends CharacterBody2D 
class_name Entity

@export_group("Entity Variables")
@export var entity_name = "NAME"
@export var entity_type = "TYPE"
@onready var health_manager = $HealthManager

@export_group("Movement")
@export var base_speed: float = 500
@export_range(0, 1) var speed_percentage: float = 1
@export var acceleration: float = 0.1
@export var friction: float = 0.1
var internal_forces: Vector2 = Vector2.RIGHT
var external_forces: Vector2
@onready var physics_collider = $PhysicsCollider




@onready var animation_machine = $AnimationMachine
@onready var state_machine = $StateMachine
@onready var sound_machine = $SoundMachine
@onready var listener = $AudioListener2D

#Visual Variables
@onready var visuals = $Visuals
@onready var sprite = $Visuals/Sprite2D


#Area3D Variables
@onready var hurtbox = $Areas/Hurtbox
var can_get_hit = true

#Healthbar
@onready var health_bar = $HealthBar/HealthBarVisual

#Node3D
@onready var nav_agent = $NavigationAgent2D


signal pain(attack_direction, facing_direction)
signal hit_effect(effect_position)

func _ready():
	self.connect("hit_effect", Callable(VFXManager, "create_hit_effect"))
	health_manager.connect("health_changed",Callable(health_bar,"set_value"))
	health_manager.connect("max_health_changed",Callable(health_bar,"set_max"))
	health_manager.emit_signal("max_health_changed", health_manager.max_health)
	health_manager.emit_signal("health_changed", health_manager.health)

	hurtbox.connect("area_entered", Callable(self,"hurt"))

func _physics_process(_delta):
	velocity = internal_forces + external_forces
	apply_friction()
	adjust_rotation_to_direction(vector_to_movement_direction(internal_forces))
	move_and_slide()

func adjust_rotation_to_direction(direction):
	if direction.x < 0:
		visuals.scale.x = -1
	else:
		visuals.scale.x = 1
	

func apply_internal_force(force_direction: Vector2):
	internal_forces = internal_forces.lerp(force_direction.normalized() * base_speed * speed_percentage, acceleration)

func apply_external_force(force_direction: Vector2, force_magnitude):
	external_forces += force_direction.normalized() * force_magnitude
	
func apply_friction():
	external_forces = external_forces.lerp(Vector2.ZERO, friction)
	internal_forces = internal_forces.lerp(Vector2.ZERO, friction)

func vector_to_movement_direction(input_vector : Vector2) -> Vector2:
	if input_vector == Vector2.ZERO:
		return Vector2.ZERO
	var aspect = abs(input_vector.aspect())
	var result = input_vector.sign()
	if aspect < 0.557852 or aspect > 1.79259:
		result[int(aspect > 1.0)] = 0
	return result




func hurt(attacker_area):
	if health_manager.is_dead() or !can_get_hit:
		return
	var knockback_direction = global_position - attacker_area.global_position
	apply_external_force(knockback_direction, attacker_area.knockback_value)
	
	health_manager.take_damage(attacker_area.damage_value)
	sound_machine.play_sound("Damage")
	
	emit_signal("hit_effect", attacker_area.global_position)
	emit_signal("pain", knockback_direction.x, visuals.scale.x)
	

func turn_off_all():
	hurtbox.turn_off()
	can_get_hit = false
	health_bar.turn_off()

func turn_on_all():
	hurtbox.turn_on()
	can_get_hit = true
	health_bar.turn_on()

#Kept in because of ease of use
func play_animation(animation, node_name):
	animation_machine.play_animation(animation, node_name)

func set_animation(duration, node_name):
	animation_machine.set_animation(duration, node_name)

func get_animation(animation, node_name):
	return animation_machine.get_animation(animation, node_name)

func get_animation_player(animation_player_name):
	return animation_machine.get_node(animation_player_name)

