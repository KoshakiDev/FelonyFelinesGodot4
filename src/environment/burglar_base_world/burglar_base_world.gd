extends Node2D

@onready var world = $World
@onready var enemies = $World/Enemies
@onready var players = $World/Players
@onready var items = $World/Items

#@onready var tile_objects = $World3D/TileObjects
#@onready var tile_floor = $World3D/TileFloor

func _ready():
	Engine.time_scale = 1
	Global.set("main", self)
	Global.set("world", world)
	Global.set("items", items)
	Global.set("players", players)
	Global.set("enemies", enemies)
	#tile_floor.delete_tiles(tile_objects)
	#tile_objects.replace_tiles_with_instances()
	#tile_floor.replace_tiles_with_instances()
	

func show_death_screen():
	SceneChanger.change_scene_to_file("res://src/menu/DeathScreen.tscn", "fade")

func back_to_menu():
	SceneChanger.change_scene_to_file("res://src/menu/Menu.tscn", "fade")
