extends Node2D


@onready var win_area = $Area2D

signal player_reached_flag

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("player_reached_flag", Callable(Global.main, "transition_to_next_scene"))
	win_area.connect("body_entered", Callable(self, "win"))

func win(body):
	print("Player won")
	emit_signal("player_reached_flag")
