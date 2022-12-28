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

func _ready():
	switch_timer.connect("timeout",Callable(self,"switch_view"))
	
	vision.vision_area.connect("body_entered", Callable(self, "body_entered_vision"))
	vision.vision_area.connect("body_exited", Callable(self, "body_exited_vision"))
	
	vision_look_in_direction(Vector2(sprite.scale.x, 0))
	
	animation_player.play("Normal")


func vision_look_in_direction(direction):
	var tween = create_tween()
	tween.tween_property(vision, "rotation", 
		-PI / 2 + direction.angle(), 0.8)
	

func body_entered_vision(body):
	vision_renderer.color = alert_color
	targets.append(body)
	switch_timer.stop()

func body_exited_vision(body):	
	targets.erase(body)
	if targets == []:
		vision_renderer.color = original_color
		switch_timer.start()
		vision_look_in_direction(Vector2(sprite.scale.x, 0))
	
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
	switch_timer.start()

