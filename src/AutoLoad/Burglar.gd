extends Node

var alert_state = false
var alert_counter = 0

var alert_timer: Timer

var alert_time_left

signal update_alert_count

func _ready():
	setup_timer()

func setup_timer():
	alert_timer = Timer.new()
	add_child(alert_timer)
	alert_timer.wait_time = 9.0
	alert_timer.one_shot = true
	alert_timer.autostart = false
	alert_timer.connect("timeout",Callable(self,"turn_off_alert_state"))

func turn_on_alert_state():
	if alert_state == false:
		alert_counter += 1
		emit_signal("update_alert_count")
	alert_state = true
	alert_timer.start()

func turn_off_alert_state():
	alert_state = false
	
func _physics_process(delta):
	if alert_time_left == null:
		return
	alert_time_left.text = str(snapped(float(alert_timer.time_left), 0.01))
