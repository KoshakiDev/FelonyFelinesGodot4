extends Node

var alert_state = false
var alert_counter = 0

var alert_timer: Timer

var alert_time_left

signal update_alert_count
signal turn_on_alert_state_for_entities
signal turn_off_alert_state_for_entities

signal show_busted_screen

func _ready():
	setup_timer()

func setup_timer():
	alert_timer = Timer.new()
	add_child(alert_timer)
	alert_timer.wait_time = 6.0
	alert_timer.one_shot = true
	alert_timer.autostart = false
	alert_timer.connect("timeout",Callable(self,"turn_off_alert_state"))

func turn_on_alert_state(has_enemy_seen_you):
	if alert_state == false || !has_enemy_seen_you:
		alert_counter += 1
		emit_signal("update_alert_count")
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
