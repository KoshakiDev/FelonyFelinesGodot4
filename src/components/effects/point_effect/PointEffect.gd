extends Node2D


const color_variants = [Color.RED, Color.AQUA, Color.YELLOW, Color.DARK_BLUE]


var autoplay: bool
var points: int
var color: Color


@onready var anim_player := $AnimationPlayer
@onready var label := $RichTextLabel
@onready var back_label := $RichTextLabel2


func _ready() -> void:
	if autoplay:
		show_effect(points, color)

func init(set_points: int, set_autoplay := true, set_color: Color = Color.RED) -> void:
	points = set_points
	color = set_color
	autoplay = set_autoplay

func show_effect(set_points: int, set_color: Color) -> void:
	#print(points, get_point_string(points))
	var point_string = get_point_string(set_points)
	label.text = point_string
	back_label.text = "[tornado radius=2 freq=10]%s[/tornado]" % point_string
	modulate = set_color
	anim_player.play("show")

func get_point_string(set_points: int) -> String:
	return ("+" if set_points > 0 else "") + str(set_points)
