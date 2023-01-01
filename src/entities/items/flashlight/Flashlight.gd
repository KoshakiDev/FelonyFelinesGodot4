extends "res://src/entities/items/base_templates/base_item/base_item.gd"

@onready var light = $Marker2D/Visuals/Sprite2D/VisionCone2D
@export var vision_renderer: Polygon2D

func _ready():
	#vision_renderer.color = Color(255, 255, 255, 73)
	#$Marker2D/AnimationMachine/AnimationPlayer.play("Idle")
	light.vision_area.connect("body_entered", Callable(self, "body_entered_vision"))
	light.vision_area.connect("body_exited", Callable(self, "body_exited_vision"))
	
func body_entered_vision(body):
	body.collision_layer += pow(2, 10-1)

func body_exited_vision(body):
	body.collision_layer -= pow(2, 10-1)

func _physics_process(delta):
	pass
	
func action():
	pass
