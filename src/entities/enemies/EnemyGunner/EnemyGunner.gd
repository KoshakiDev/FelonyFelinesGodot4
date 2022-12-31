extends "res://src/entities/base_templates/base_npc/base_npc.gd"

signal drop_specific_weapon(drop_position, weapon_name)
@onready var item_holder = $Visuals/Sprite2D/ItemHolder
@export var max_shooting_distance = 500

var is_shot_ready = true

func _ready():
	super._ready()
	item_holder.init(self)
	connect("drop_specific_weapon", Callable(Global, "drop_specific_weapon"))

func _physics_process(delta):
	super._physics_process(delta)
	#item_holder.shoot()

func turn_on_all():
	super.turn_on_all()
	item_holder.visible = true

func turn_off_all():
	super.turn_off_all()
	item_holder.visible = false

func attack(target):
	var target_position = target.global_position
	var look_direction = ((target_position) - global_position).normalized()
	adjust_rotation_to_direction(look_direction)
	item_holder.shoot()

func adjust_rotation_to_direction(direction):
	super.adjust_rotation_to_direction(direction)
	
	if visuals.scale.x == -1:
		item_holder.rotation = PI - direction.angle()
	elif visuals.scale.x == 1:
		item_holder.rotation = direction.angle()
	
