extends Node2D

@onready var sprite_key = $Key
@onready var anim_player = $AnimationPlayer
@onready var area = $Area2D
@export var current_key = ""

var key_hint_textures = {
	"action_1": "res://test/SimpleKeys/Jumbo/Light/Spritesheets/SPACEALTERNATIVE.png",
	"prev_weapon_1": "res://test/SimpleKeys/Jumbo/Light/Spritesheets/Q.png",
	"next_weapon_1": "res://test/SimpleKeys/Jumbo/Light/Spritesheets/E.png",
	"up_1":  "res://test/SimpleKeys/Jumbo/Light/Spritesheets/W.png",
	"right_1": "res://test/SimpleKeys/Jumbo/Light/Spritesheets/D.png",
	"down_1": "res://test/SimpleKeys/Jumbo/Light/Spritesheets/S.png",
	"left_1": "res://test/SimpleKeys/Jumbo/Light/Spritesheets/A.png",
	
}

func _ready():
	hide()
	area.connect("body_entered", Callable(self, "show_key"))
	

func _input(event):
	if event.is_action_pressed(current_key):
		hide()

func show_key(body):
	visible = true
	sprite_key.set_texture(load(key_hint_textures[current_key]))
	anim_player.play("Animate")

func hide():
	visible = false
	anim_player.stop()

