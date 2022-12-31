extends Node2D

@export_group("Vision Settings")
@onready var vision = $VisionCone2D
@export var vision_renderer: Polygon2D
@export var alert_color: Color
@onready var original_color = vision_renderer.color if vision_renderer else Color.WHITE

var targets = []
@onready var sprite = $Sprite2D
@onready var switch_timer = $SwitchTimer
@onready var animation_player = $AnimationPlayer

@export var normal_color = Color(0, 1, 0, 0.74902)
@export var suspicion_color = Color(1, 0.796078, 0, 0.74902)
@export var detected_color = Color(1, 0, 0, 0.74902)

signal turn_on_alert_state(has_seen_you)
var has_seen_you = false

func _ready():
	setup_burglar_mode()
	setup_vision()
	vision_renderer.color = suspicion_color
	
	vision_look_in_direction(Vector2(sprite.scale.x, 0))
	switch_timer.connect("timeout", Callable(self,"switch_view"))
	
	animation_player.play("Normal")

func setup_vision():
	vision.vision_area.connect("body_entered", 
		Callable(self, "body_entered_vision"))
	vision.vision_area.connect("body_exited", 
		Callable(self, "body_exited_vision"))


func setup_burglar_mode():
	connect("turn_on_alert_state", 
		Callable(Burglar, "turn_on_alert_state"))
	Burglar.connect("turn_on_alert_state_for_entities", 
		Callable(self, "go_alert_state"))
	Burglar.connect("turn_off_alert_state_for_entities", 
		Callable(self, "go_normal_state"))

func vision_look_in_direction(direction):
	var tween = create_tween()
	tween.tween_property(vision, "rotation", 
		-PI / 2 + direction.angle(), 0.8)
	
#TODO: Switch to constant instead of magic numbers
func go_alert_state():
	switch_timer.wait_time = 1
	switch_timer.stop()
	switch_timer.start()
	print("went into alert state")

func go_normal_state():
	switch_timer.wait_time = 3
	switch_timer.stop()
	switch_timer.start()
	has_seen_you = false
	print("went into normal state")

func body_entered_vision(body):
	emit_signal("turn_on_alert_state", has_seen_you)
	has_seen_you = true
	vision_renderer.color = detected_color
	targets.append(body)
	
func body_exited_vision(body):	
	targets.erase(body)
	if targets == []:
		vision_renderer.color = suspicion_color
		
func begin_suspicion():
	animation_player.play("Suspicion")

func target_detected(_target):
	animation_player.play("Detected")

func target_lost():
	animation_player.play("Normal")


func _physics_process(_delta):
	pass
	
func switch_view():
	sprite.scale.x *= -1
	vision_look_in_direction(Vector2(sprite.scale.x, 0))
	#switch_timer.start()

