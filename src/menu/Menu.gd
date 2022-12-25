extends Node2D

@export var level = "res://src/environment/LaunchScene.tscn"

func _ready():
	$CanvasLayer/Sprite2D.visible = true
	$AnimationPlayer.play("idle")

func _input(event):
	if event is InputEventKey:
		if event.pressed:
			SceneChanger.change_scene_to_file(level, "fade")
			$CanvasLayer/Sprite2D.visible = false
