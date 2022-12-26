@tool
extends Control

@export_group("Split Screen Settings")
@export var max_separation:float = 400.0
@export var split_line_thickness:float = 3.0
@export var split_line_color:Color = Color.BLACK
@export var adaptive_split_line_thickness:bool = true

@onready var view = $View
@onready var viewport_1 = $SubViewport1
@onready var viewport_2 = $SubViewport2
@onready var camera_1 = $SubViewport1/Camera1
@onready var camera_2 = $SubViewport2/Camera2

@export_group("Target Objects")
@export var object_1_path: NodePath
@export var object_2_path: NodePath

var object_1: Node2D
var object_2: Node2D


func _ready():
	visible = true
	setup()


func setup():
	if object_1_path == null or object_2_path == null:
		printerr("SPLIT SCREEN ERROR: Object path(s) are null!")
		set_physics_process(false)
		return
	
	object_1 = get_node(object_1_path)
	object_2 = get_node(object_1_path)
	
	Shake.set_camera(camera_1, camera_2)
	
	viewport_2.world_2d = viewport_1.world_2d
	_on_size_changed()
	_update_splitscreen()
	get_viewport().connect("size_changed",Callable(self,"_on_size_changed"))

	camera_1.set_current(true)
	await RenderingServer.frame_post_draw
	view.material.set_shader_parameter("viewport1", viewport_1.get_texture())
	
	camera_2.set_current(true)
	await RenderingServer.frame_post_draw
	view.material.set_shader_parameter("viewport2", viewport_2.get_texture())

	

	
func _physics_process(delta):
	_move_cameras()
	_update_splitscreen()

func _move_cameras():
	var position_difference = _compute_position_difference_in_world()
	
	var distance = clamp(position_difference.length(), 0, max_separation)

	position_difference = position_difference.normalized() * distance
	
	camera_1.global_position = object_1.global_position + position_difference / 2.0
	camera_2.global_position = object_2.global_position - position_difference / 2.0

func _compute_position_difference_in_world():
	return object_1.global_position - object_2.global_position


func _update_splitscreen():
	var screen_size = get_viewport().get_visible_rect().size

	var topLeft1 = camera_1.get_screen_center_position() - screen_size / 2.0
	var topLeft2 = camera_2.get_screen_center_position() - screen_size / 2.0

	var object_1_position = (object_1.global_position - topLeft1) / screen_size
	var object_2_position = (object_2.global_position - topLeft2) / screen_size

	var thickness = 0.0
	if adaptive_split_line_thickness:
		var position_difference = _compute_position_difference_in_world()
		var distance = position_difference.length()
		
		print(split_line_thickness)
		print((distance - max_separation) / max_separation)
		thickness = lerp(0, split_line_thickness, 
				(distance - max_separation) / max_separation)
		thickness = clamp(thickness, 0, split_line_thickness)
	else:
		thickness = split_line_thickness

	view.material.set_shader_parameter("split_active", _get_split_state())
	view.material.set_shader_parameter("hide_object_1", false)
	view.material.set_shader_parameter("hide_object_2", false)
	view.material.set_shader_parameter("object_1_position", object_1_position)
	view.material.set_shader_parameter("object_2_position", object_2_position)
	view.material.set_shader_parameter("split_line_thickness", thickness)
	view.material.set_shader_parameter("split_line_color", split_line_color)
	

func _get_split_state():
	var position_difference = _compute_position_difference_in_world()
	var separation_distance = position_difference.length()
	return separation_distance > max_separation
	
func _on_size_changed():
	var screen_size = get_viewport().get_visible_rect().size
	viewport_1.size = screen_size
	viewport_2.size = screen_size
	view.size = screen_size
	view.material.set_shader_parameter("viewport_size", screen_size)
	
