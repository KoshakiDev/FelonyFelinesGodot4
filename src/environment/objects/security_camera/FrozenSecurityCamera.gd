extends "res://src/environment/objects/security_camera/SecurityCamera.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	switch_timer.stop()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#TODO: Switch to constant instead of magic numbers
func go_alert_state():
	awareness_meter = 0.99
	#print("went into alert state")

func go_normal_state():
	has_seen_you = false
	#print("went into normal state")
