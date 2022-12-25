extends Area2D


@export var WINDOW: PackedScene

var target = null
var window = null

signal minigame_success
signal window_created

func _ready():
	if WINDOW == null:
		printerr("WARNING: No interaction window found!")
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
	if target.interacting:
		return 
	if Input.is_action_just_pressed("action_2"):
		create_window(target)

func create_window(player_body: Node2D):
	window = WINDOW.instantiate()
	window.target = player_body
	Global.UI_layer.add_child(window)
	emit_signal("window_created")
	window.connect("minigame_success",Callable(self,"minigame_success"))

func minigame_success():
	emit_signal("minigame_success")

func player_detected(body):
	target = body
	
func player_lost(body):
	target = null
