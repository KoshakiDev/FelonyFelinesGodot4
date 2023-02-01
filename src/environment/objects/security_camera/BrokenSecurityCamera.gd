extends "res://src/environment/objects/security_camera/SecurityCamera.gd"

@onready var flicker_timer = $FlickerTimer

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	switch_timer.stop()
	
	flicker_timer.connect("timeout", Callable(self, "flicker"))

func setup_burglar_mode():
	pass

func detected():
	#emit_signal("intruder_effect", global_position)
	#emit_signal("turn_on_alert_state", has_seen_you)
	has_seen_you = true
	#vision_renderer.color = detected_color

func _physics_process(_delta):
	super._physics_process(_delta)
	#flicker()
	
func flicker():
	if vision_renderer.visible == true:
		vision_renderer.visible = false
	else:
		vision_renderer.visible = true

