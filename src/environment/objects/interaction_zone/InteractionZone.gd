extends Area2D

var target = null

signal hint

func _ready():
	connect("body_entered",Callable(self,"player_detected"))
	connect("body_exited",Callable(self,"player_lost"))

func turn_off():
	monitorable = false
	monitoring = false

func turn_on():
	monitorable = true
	monitoring = true

func _physics_process(delta):
	if target == null:
		return
	show_hint()

func show_hint():
	emit_signal("hint")

func player_detected(body):
	target = body
	
func player_lost(body):
	target = null
