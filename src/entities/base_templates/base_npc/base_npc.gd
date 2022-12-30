extends "res://src/entities/base_templates/base_entity/base_entity.gd"

@export_group("Vision Settings")
@onready var vision = $Areas/VisionCone2D
@export var vision_renderer: Polygon2D
@export var alert_color: Color
@export var sus_color: Color
@onready var original_color = vision_renderer.color if vision_renderer else Color.WHITE

# Non-Player Variables
@export_group("Item Drop Variables")
@export var ITEM_DROP_PERCENT = 50

signal points_effect(effect_position, points_amount)
signal update_points(points_amount)
signal drop_weapon(drop_position)
signal update_board()
signal turn_on_alert_state

var has_seen_you = false

var targets = []
var last_target_position
@onready var sus_timer = $Areas/SusTimer


@onready var forget_timer = $ForgetTimer
@onready var update_internal_force_timer = $UpdateInternalForceTimer

var current_facing_direction = 0
var vector_directions = [Vector2.RIGHT, Vector2.LEFT, Vector2.UP, Vector2.DOWN]



func _ready():
	super._ready()
	setup_burglar_mode()
	connect("drop_weapon", Callable(Global, 
		"drop_weapon"))
	connect("points_effect", 
		Callable(VFXManager, "create_points_effect"))
	forget_timer.connect("timeout", 
		Callable(self, "forget_last_position"))
	sus_timer.connect("timeout", Callable(self, "become_alert"))
	
	setup_vision()
	setup_look_direction()
	
	
func setup_burglar_mode():
	connect("turn_on_alert_state", 
		Callable(Burglar, "turn_on_alert_state"))
	Burglar.connect("turn_on_alert_state_for_entities", 
		Callable(self, "go_alert_state"))
	Burglar.connect("turn_off_alert_state_for_entities", 
		Callable(self, "go_normal_state"))
	
	
func _physics_process(delta):
	super._physics_process(delta)

func adjust_rotation_to_direction(direction):
	super.adjust_rotation_to_direction(direction)
	vision_look_in_direction(direction)

func vision_look_in_direction(direction):
	var tween = create_tween()
	tween.tween_property(vision, "rotation", 
		-PI / 2 + direction.angle(), 0.01)
	
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
	emit_signal("turn_on_alert_state", has_seen_you)
	has_seen_you = true
	
func body_exited_vision(body):
	targets.erase(body)
	if targets == []:
		vision_renderer.color = original_color
	set_last_position(body.global_position)

func attack(_target):
	pass

func hurt(attacker_area):
	super.hurt(attacker_area)
	if attacker_area is Projectile:
		set_last_position(attacker_area.start_position)
	else:
		set_last_position(attacker_area.global_position)
	#Global.frame_freeze(0.5, 2)

func turn_off_all():
	super.turn_off_all()
	vision.turn_off()
	update_internal_force_timer.stop()

func turn_on_all():
	super.turn_on_all()
	vision.turn_on()
	update_internal_force_timer.start()


# TODO: Remove magic numbers
func go_alert_state():
	update_internal_force_timer.wait_time = 0.5
	#print("went into alert state")

func go_normal_state():
	update_internal_force_timer.wait_time = 2.5
	has_seen_you = false
	#print("went into normal state")


func set_last_position(target_position):
	last_target_position = target_position
	forget_timer.start()

func forget_last_position():
	last_target_position = null

func setup_vision():
	vision.vision_area.connect("body_entered", 
		Callable(self, "body_entered_vision"))
	vision.vision_area.connect("body_exited", 
		Callable(self, "body_exited_vision"))
	
func setup_look_direction():
	internal_forces = Vector2.ZERO
	change_look_direction()
	update_internal_force_timer.connect("timeout", 
		Callable(self, "change_look_direction"))
	
func change_look_direction():
	var random = RandomNumberGenerator.new()
	random.randomize()
	if internal_forces != Vector2.ZERO:
		internal_forces -= vector_directions[current_facing_direction]
	current_facing_direction = random.randi_range(0, 3)
	internal_forces += vector_directions[current_facing_direction]
	
