extends Node2D

@onready var light = $VisionCone2D
@export var vision_renderer: Polygon2D
# Called when the node enters the scene tree for the first time.
func _ready():
	#vision_renderer.color = Color(255, 255, 255, 73)
	light.vision_area.connect("body_entered", Callable(self, "body_entered_vision"))
	light.vision_area.connect("body_exited", Callable(self, "body_exited_vision"))
	
func body_entered_vision(body):
	body.collision_layer += pow(2, 10-1)

func body_exited_vision(body):
	body.collision_layer -= pow(2, 10-1)
