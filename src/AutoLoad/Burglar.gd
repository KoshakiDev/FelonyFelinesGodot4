extends Node

var alert_state = false
var alert_counter = 0

var alert_timer: Timer

var alert_buffer_timer: Timer

var alert_time_left

signal update_alert_count
signal turn_on_alert_state_for_entities
signal turn_off_alert_state_for_entities

signal show_busted_screen

func _ready():
	setup_timer()
	setup_alert_buffer_timer()

func setup_alert_buffer_timer():
	alert_buffer_timer = Timer.new()
	add_child(alert_buffer_timer)
	alert_buffer_timer.wait_time = 1.0
	alert_buffer_timer.one_shot = true
	alert_buffer_timer.autostart = false
	#alert_buffer_timer.connect("timeout",Callable(self,"turn_off_alert_state"))

func setup_timer():
	alert_timer = Timer.new()
	add_child(alert_timer)
	alert_timer.wait_time = 30.0
	alert_timer.one_shot = true
	alert_timer.autostart = false
	alert_timer.connect("timeout",Callable(self,"turn_off_alert_state"))

func turn_on_alert_state(has_enemy_seen_you):
	if alert_state == false || !has_enemy_seen_you:
		if alert_buffer_timer.is_stopped():
			alert_counter += 1
			VFXManager.emit_signal("create_shockwave_effect")
			emit_signal("update_alert_count")
			alert_buffer_timer.start()
		emit_signal("turn_on_alert_state_for_entities")
	alert_state = true
	alert_timer.start()

func turn_off_alert_state():
	alert_state = false
	emit_signal("turn_off_alert_state_for_entities")
	
	
func _physics_process(delta):
	if alert_time_left == null:
		return
	alert_time_left.text = str(snapped(alert_timer.time_left, 1))


func start_game_over():
	emit_signal("show_busted_screen")

func game_over():
	reset_everything()
	get_tree().reload_current_scene()


func reset_everything():
	alert_timer.stop()
	alert_counter = 0
	alert_state = false
