extends Node2D

@onready var world = $World

func _ready():
	Global.set("main", self)
	Global.set("world", world)

func show_death_screen():
	SceneChanger.change_scene_to_file("res://src/menu/DeathScreen.tscn", "fade")

func back_to_menu():
	SceneChanger.change_scene_to_file("res://src/menu/Menu.tscn", "fade")
