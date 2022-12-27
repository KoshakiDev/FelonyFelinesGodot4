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

var last_target_position
var forget_timer = $ForgetTimer

func _ready():
	super._ready()
	connect("points_effect", Callable(VFXManager, "create_points_effect"))
	vision.vision_area.connect("body_entered", Callable(self, "body_entered_vision"))
	vision.vision_area.connect("body_exited", Callable(self, "body_exited_vision"))
	forget_timer.connect("timeout", Callable(self, "forget_timer_timeout"))

func _physics_process(delta):
	super._physics_process(delta)

func adjust_rotation_to_direction(direction):
	super.adjust_rotation_to_direction(direction)
	var target = get_target()
	
	if target == null && last_target_position == null:
		return
	
	var target_pos
	if target == null:
		target_pos = last_target_position
	else:
		target_pos = target.global_position
	
	vision_look_at(target_pos)
	
	
func vision_look_at(target_pos):
	var tween = create_tween()
	tween.tween_property(vision, "rotation", 
		-PI / 2 + (target_pos - global_position).angle(), 0.01)



func get_target():
	if targets == []:
		return
	for target in targets:
		return target

func body_entered_vision(body):
	vision_renderer.color = alert_color
	targets.append(body)

func body_exited_vision(body):	
	targets.erase(body)
	if targets == []:
		vision_renderer.color = original_color
	last_target_position = body.global_position
	forget_timer.start()

func attack(_target):
	pass
	

func hurt(attacker_area):
	super.hurt(attacker_area)
	var look_direction = (attacker_area.global_position - global_position).normalized()
	look_direction.x = round(look_direction.x)
	look_direction.y = round(look_direction.y)
	
	print(look_direction)
	adjust_rotation_to_direction(look_direction)
	vision_look_at(attacker_area.global_position)
	#Global.frame_freeze(0.5, 2)

func forget_timer_timeout():
	last_target_position = null
