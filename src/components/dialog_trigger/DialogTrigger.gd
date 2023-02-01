extends Node2D

@export var dialogic_path = ""

@onready var area = $Area2D

var already_triggered = false

@export var text = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	area.connect("body_entered", Callable(self, "activate_dialog"))

func activate_dialog(body):
	if already_triggered:
		return
	#Global.main.add_child(Dialogic.start_timeline(load(dialogic_path)))
	#already_triggered = true
