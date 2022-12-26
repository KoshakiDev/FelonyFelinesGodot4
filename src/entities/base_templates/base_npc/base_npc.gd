extends "res://src/entities/base_templates/base_entity/base_entity.gd"

@export_group("Vision Settings")
@onready var vision = $Areas/VisionCone2D
@export var vision_renderer: Polygon2D
@export var alert_color: Color
@onready var original_color = vision_renderer.color if vision_renderer else Color.WHITE

# Non-Player Variables
@export_group("Item Drop Variables")
@export var ITEM_DROP_PERCENT = 50

signal points_effect(effect_position, points_amount)
signal update_points(points_amount)

var targets = []


func _ready():
	super._ready()
	connect("points_effect", Callable(VFXManager, "create_points_effect"))
	vision.vision_area.connect("body_entered", Callable(self, "body_entered_vision"))
	vision.vision_area.connect("body_exited", Callable(self, "body_exited_vision"))

func _physics_process(delta):
	super._physics_process(delta)

func adjust_rotation_to_direction(direction):
	super.adjust_rotation_to_direction(direction)
	vision.look_at(vision.global_position + direction)
	


func get_target():
	if targets == []:
		return
	for target in targets:
		return target

func body_entered_vision(body):
	vision_renderer.color = alert_color
	targets.append(body)

func body_exited_vision(body):	
	vision_renderer.color = original_color
	targets.erase(body)

func attack(target):
	pass
	

func hurt(attacker_area):
	super.hurt(attacker_area)
	#Global.frame_freeze(0.5, 2)
