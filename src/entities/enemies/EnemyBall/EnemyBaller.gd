extends "res://src/entities/base_templates/base_npc/base_npc.gd"

@export_group("Dash Settings")
@export var cooldown_duration: float = 5
@export var dash_duration: float = 3
@export var dash_speed: int = 30

@onready var hitbox = $Areas/Hitbox

func _ready():
	super._ready()

func turn_on_all():
	super.turn_off_all()
	hitbox.turn_on()


func turn_off_all():
	super.turn_off_all()
	hitbox.turn_off()


var dash_direction = Vector2.ZERO


func attack(target):
	dash_direction = (target.global_position - global_position).normalized() * dash_speed
	apply_dash(dash_direction)

func apply_dash(direction):
	internal_forces = direction * dash_speed

func search_for_target():
	return Global.get_farthest_player(global_position)
