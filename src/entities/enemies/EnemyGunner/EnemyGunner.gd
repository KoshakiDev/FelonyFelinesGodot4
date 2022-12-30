extends "res://src/entities/base_templates/base_npc/base_npc.gd"

signal drop_specific_weapon(drop_position, weapon_name)
@onready var item_holder = $Visuals/Sprite2D/ItemHolder
@onready var update_margin_of_error_timer = $UpdateAimMarginOfError
@export var max_shooting_distance = 500

func _ready():
	super._ready()
	item_holder.init(self)
	update_margin_of_error_timer.connect("timeout", Callable(self, "update_margin_of_error"))
	update_margin_of_error()
	connect("drop_specific_weapon", Callable(Global, "drop_specific_weapon"))

func turn_on_all():
	super.turn_on_all()
	item_holder.visible = true

func turn_off_all():
	super.turn_off_all()
	item_holder.visible = false

var margin_of_error_in_position 

func update_margin_of_error():
	margin_of_error_in_position = Vector2(randi_range(-100, 100), randi_range(-100, 100))

func attack(target):
	var target_position
	if (abs(margin_of_error_in_position.x) < target.global_position.x ||
		abs(margin_of_error_in_position.y) < target.global_position.y):
		target_position = target.global_position
	else:
		target_position = target.global_position + margin_of_error_in_position
	var look_direction = ((target_position) - global_position).normalized()
	adjust_rotation_to_direction(look_direction)
	item_holder.shoot()

func adjust_rotation_to_direction(direction):
	super.adjust_rotation_to_direction(direction)
	
	if visuals.scale.x == -1:
		item_holder.rotation = PI - direction.angle()
	elif visuals.scale.x == 1:
		item_holder.rotation = direction.angle()
	
