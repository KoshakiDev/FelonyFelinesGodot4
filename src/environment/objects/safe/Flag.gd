extends Node2D


@onready var win_area = $Area2D
# Called when the node enters the scene tree for the first time.
func _ready():
	win_area.connect("body_entered", Callable(self, "win"))

func win(body):
	print("Player won")
