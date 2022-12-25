#Movement Script
extends Node3D

var body: CharacterBody3D = null

var frozen = false

#Physics Variables
@export var max_speed: float = 225
var actual_velocity: Vector3
var horizontal_intended_velocity: Vector3
var	vertical_intended_velocity: Vector3

var knockback: Vector3

var movement_direction: Vector3 = Vector3.ZERO

#Jump variables
@export var jump_height : float
@export var jump_time_to_peak : float
@export var jump_time_to_descent : float

@onready var jump_velocity : float = (2.0 * jump_height) / jump_time_to_peak
@onready var jump_gravity : float = (2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)
@onready var fall_gravity : float = (2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)

func init(_body_to_move: CharacterBody3D):
	body = _body_to_move

func horizontal_move(force: Vector3):
	force.y = 0
	var force_direction = force.normalized()
	horizontal_intended_velocity = horizontal_intended_velocity.lerp(force_direction * max_speed, Global.ACCEL)
	
func jump():
	vertical_intended_velocity.y = jump_velocity

func negate_jump():
	vertical_intended_velocity.y = 0
	
func get_gravity() -> float:
	return jump_gravity if vertical_intended_velocity.y > 0.0 else fall_gravity


func _physics_process(delta):
	if frozen:
		return
	actual_velocity = horizontal_intended_velocity + vertical_intended_velocity + knockback
	knockback = knockback.lerp(Vector3.ZERO, Global.FRICTION)
	horizontal_intended_velocity = horizontal_intended_velocity.lerp(Vector3.ZERO, Global.FRICTION)
	if !body.is_on_floor():
		pass
		#vertical_intended_velocity += Vector3.DOWN * get_gravity() * delta
	body.set_velocity(actual_velocity)
	body.set_up_direction(Vector3.UP)
	body.move_and_slide()
	body.velocity
	

func freeze():
	frozen = true

func unfreeze():
	frozen = false
