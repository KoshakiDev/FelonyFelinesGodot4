extends "res://src/entities/base_templates/base_entity/base_entity.gd"

@export_group("Vision Settings")
@onready var vision = $Areas/VisionCone2D
@export var vision_renderer: Polygon2D
@export var normal_color = Color(1, 0.796078, 0, 0.74902)
@export var detected_color = Color(1, 0, 0, 0.74902)
var awareness_meter = 0
@export var awareness_increment = 0.02
@export var awareness_decrement = 0.001
# Non-Player Variables
@export_group("Item Drop Variables")
@export var ITEM_DROP_PERCENT = 50

signal points_effect(effect_position, points_amount)
signal update_points(points_amount)
signal drop_weapon(drop_position)
signal update_board()
signal turn_on_alert_state
signal intruder_effect(effect_position)
signal ouch_effect(effect_position)

var has_seen_you = false

var burglar_mode = false

var targets = []
var already_seen_shooters = []
var last_target_position

var path_points = []

@onready var forget_timer = $ForgetTimer
@onready var update_internal_force_timer = $UpdateInternalForceTimer

var current_facing_direction = randi_range(0, 3)
var vector_directions = [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP]



func _ready():
	super._ready()
	setup_burglar_mode()
	connect("drop_weapon", Callable(Global, 
		"drop_weapon"))
	connect("points_effect", 
		Callable(VFXManager, "create_points_effect"))
	forget_timer.connect("timeout", 
		Callable(self, "forget_last_position"))
	setup_vision()
	setup_look_direction()
	connect("ouch_effect",
		Callable(VFXManager, "create_ouch_effect"))
	

func _physics_process(delta):
	super._physics_process(delta)
	awareness()

func awareness():
	var tween = create_tween()
	
	var new_color: Color
	
	if awareness_meter == 1 && !has_seen_you:
		detected()
	if targets != []:
		awareness_meter = clamp(awareness_meter + awareness_increment,
								0, 1)
		new_color = lerp(normal_color, detected_color, awareness_meter)
		tween.tween_property(vision_renderer, "color", 
			new_color, 0.2)
	else:
		#vision_renderer.color = normal_color
		awareness_meter = clamp(awareness_meter - awareness_decrement,
								0, 1)
		new_color = lerp(normal_color, detected_color, awareness_meter)
		tween.tween_property(vision_renderer, "color", 
			new_color, 0.2)

func adjust_rotation_to_direction(direction):
	super.adjust_rotation_to_direction(direction)
	vision_look_in_direction(direction)
	vision.global_position = global_position + direction * 10
	

func vision_look_in_direction(direction):
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(vision, "rotation", 
		-PI / 2 + direction.angle(), 0.01)
	tween.tween_property(vision_renderer, "texture_rotation", 
		-PI / 2 + direction.angle(), 0.01)

func detected():
	emit_signal("intruder_effect", global_position)
	sound_machine.play_sound("Intruder")
	emit_signal("turn_on_alert_state", has_seen_you)
	has_seen_you = true

func get_target():
	if targets == []:
		return
	for target in targets:
		return target

func get_path_point():
	if path_points == []:
		return
	return path_points[path_points.size() - 1]

func area_entered_vision(area):
	if area.is_in_group("PATH_POINT"):
		path_points.append(area)
		return
	
	if area.get("bullet_owner"):
		if area.bullet_owner == self || already_seen_shooters.has(area.bullet_owner):
			return
		if area.bullet_owner.get("player_id") == null:
			already_seen_shooters.append(area.bullet_owner)
	set_last_position(area.global_position)
	targets.append(area)
	
func area_exited_vision(area):
	if area.is_in_group("PATH_POINT"):
		path_points.erase(area)
		return
	
	if area.get("bullet_owner"):
		if area.bullet_owner == self:
			return
	targets.erase(area)
	#set_last_position(area.global_position)

	#body_exited_vision(area)

func body_entered_vision(body):
	targets.append(body)
	
func body_exited_vision(body):
	targets.erase(body)
	set_last_position(body.global_position)

func attack(_target):
	pass

func hurt(attacker_area):
	super.hurt(attacker_area)
	if attacker_area is Projectile:
		set_last_position(attacker_area.start_position)
	else:
		if attacker_area.hitbox_owner != null:
			set_last_position(attacker_area.hitbox_owner.global_position)
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
	awareness_meter = 0.99
	#print("went into alert state")

func go_normal_state():
	has_seen_you = false
	already_seen_shooters = []
	#print("went into normal state")


func set_last_position(target_position):
	last_target_position = target_position
	forget_timer.start()

func forget_last_position():
	last_target_position = null

func forget_all_path_points():
	path_points = []

func setup_vision():
	vision.vision_area.connect("body_entered", 
		Callable(self, "body_entered_vision"))
	vision.vision_area.connect("body_exited", 
		Callable(self, "body_exited_vision"))
	
	vision.vision_area.connect("area_entered", 
		Callable(self, "area_entered_vision"))
	vision.vision_area.connect("area_exited", 
		Callable(self, "area_exited_vision"))
	vision_renderer.color = normal_color

func setup_look_direction():
	internal_forces = Vector2.ZERO
	change_look_direction()
	update_internal_force_timer.connect("timeout", 
		Callable(self, "change_look_direction"))

func setup_burglar_mode():
	connect("intruder_effect", 
		Callable(VFXManager, "create_intruder_effect"))
	burglar_mode = true
	connect("turn_on_alert_state", 
		Callable(Burglar, "turn_on_alert_state"))
	Burglar.connect("turn_on_alert_state_for_entities", 
		Callable(self, "go_alert_state"))
	Burglar.connect("turn_off_alert_state_for_entities", 
		Callable(self, "go_normal_state"))

func change_look_direction():
	current_facing_direction = (current_facing_direction + 1) % 4
	internal_forces = vector_directions[current_facing_direction]
	
