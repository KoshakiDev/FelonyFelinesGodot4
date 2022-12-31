extends Node2D

@export_group("Vision Settings")
@onready var vision = $VisionCone2D
@export var vision_renderer: Polygon2D
@export var normal_color = Color(1, 0.796078, 0, 0.74902)
@export var detected_color = Color(1, 0, 0, 0.74902)

@onready var original_color = vision_renderer.color if vision_renderer else Color.WHITE

var targets = []
var targets_different = []
@onready var sprite = $Sprite2D
@onready var switch_timer = $SwitchTimer
@onready var animation_player = $AnimationPlayer

var awareness_meter = 0
var awareness_increment = 0.02
var awareness_decrement = 0.001

signal turn_on_alert_state(has_seen_you)
var has_seen_you = false

func _ready():
	setup_burglar_mode()
	setup_vision()
	
	vision_look_in_direction(Vector2(sprite.scale.x, 0))
	switch_timer.connect("timeout", Callable(self,"switch_view"))
	
	animation_player.play("Normal")



func setup_vision():
	vision.vision_area.connect("body_entered", 
		Callable(self, "body_entered_vision"))
	vision.vision_area.connect("body_exited", 
		Callable(self, "body_exited_vision"))
	vision_renderer.color = normal_color
	
func setup_burglar_mode():
	connect("turn_on_alert_state", 
		Callable(Burglar, "turn_on_alert_state"))
	Burglar.connect("turn_on_alert_state_for_entities", 
		Callable(self, "go_alert_state"))
	Burglar.connect("turn_off_alert_state_for_entities", 
		Callable(self, "go_normal_state"))

func vision_look_in_direction(direction):
	var tween = create_tween()
	tween.set_parallel()	
	tween.tween_property(vision, "rotation", 
		-PI / 2 + direction.angle(), 0.8)
	tween.tween_property(vision_renderer, "texture_rotation", 
		-PI / 2 + direction.angle(), 0.8)
	
#TODO: Switch to constant instead of magic numbers
func go_alert_state():
	switch_timer.wait_time = 1
	switch_timer.stop()
	switch_timer.start()
	awareness_meter = 0.99
	print("went into alert state")

func go_normal_state():
	switch_timer.wait_time = 3
	switch_timer.stop()
	switch_timer.start()
	has_seen_you = false
	print("went into normal state")

func body_entered_vision(body):
	targets.append(body)

func body_exited_vision(body):
	targets.erase(body)

func detected():
	emit_signal("turn_on_alert_state", has_seen_you)
	has_seen_you = true
	#vision_renderer.color = detected_color

func awareness():
	var tween = create_tween()
	
	var new_color: Color
	
	if awareness_meter == 1:
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
	

func _physics_process(_delta):
	awareness()

func switch_view():
	sprite.scale.x *= -1
	vision_look_in_direction(Vector2(sprite.scale.x, 0))

