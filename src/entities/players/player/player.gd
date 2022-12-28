extends "res://src/entities/base_templates/base_entity/base_entity.gd"

@export var player_id = "_1"
const red_sprite = preload("res://assets/entities/players/red_brother_sheet_96x96.png")
const blue_sprite = preload("res://assets/entities/players/blue_brother_sheet_96x96.png")

@onready var inventory_position = $Visuals/Sprite2D/InventoryPosition
@onready var item_manager := $Visuals/Sprite2D/InventoryPosition/ItemManager
@onready var dust_spawner = $Visuals/DustSpawner

@onready var item_pickup = $Areas/ItemPickup
@onready var respawn_radius = $Areas/Respawn

@onready var ammo_bar = $AmmoBar

var player_visual_middle = Vector2(0, -50)

var is_resistance = false

signal player_died
#signal hidden
signal unhidden
##sounds

var is_in_shadow = false
var is_hidden = false : set = set_hidden


func set_hidden(new_value):
	is_hidden = new_value
	if is_hidden:
		emit_signal("hidden")
	else:
		emit_signal("unhidden")

var interacting = false

func hide():
	animation_machine.play_animation("Hidden", "Hidden")


func unhide():
	animation_machine.play_animation("Unhidden", "Hidden")


func _ready():
	super._ready()
	setup_player()
	self.connect("hidden",Callable(self,"hide"))
	self.connect("unhidden",Callable(self,"unhide"))
	item_manager.init(self, ammo_bar)

func setup_player():
	if player_id == "_1":
		$HealthBar.position.y = -85 + 10
		inventory_position.position.y += 10
		sprite.set_texture(red_sprite)
		player_visual_middle = Vector2(0, -50 + 10)
		listener.current = true;
	
	elif player_id == "_2":
		$HealthBar.position.y = -85
		inventory_position.position.y += 0
		sprite.set_texture(blue_sprite)
		player_visual_middle = Vector2(0, -50)
	#Global.set("brother" + player_id, self)
	#connect("player_died",Callable(Global,"player_died"))

func _input(event):
	if event.is_action_pressed("escape") && health_manager.is_dead():
		respawn_player()
		health_manager.heal(100)


func adjust_rotation_to_direction(direction):
	super.adjust_rotation_to_direction(direction)
	item_manager.look_at(item_manager.global_position + direction)

func _physics_process(_delta):
	super._physics_process(_delta)
	#print(weapon_manager.weapons)

func hurt(attacker_area):
	super.hurt(attacker_area)
	Shake.shake(4.0, .5)
	
	
# func frame_freeze(time_scale, duration):
# 	Engine.time_scale = time_scale
# 	await get_tree().create_timer(duration * time_scale).timeout
# 	Engine.time_scale = 1.0

func respawn_player():
	play_animation("Respawn", "Movement")
	await get_animation_player("Movement").animation_finished
	health_manager.heal(health_manager.max_health / 10)
	turn_on_all()
	state_machine.transition_to("Idle")


func turn_off_all():
	super.turn_off_all()
	ammo_bar.visible = false
	
	if item_manager.cur_item != null:
		item_manager.cur_item.set_inactive()
	item_manager.visible = false
	respawn_radius.activate_respawn_radius()
	collision_layer -= pow(2, 2-1)
	emit_signal("player_died")

func turn_on_all():
	super.turn_on_all()
	ammo_bar.visible = true
	if item_manager.cur_item != null:
		item_manager.cur_item.set_active()
	item_manager.visible = true
	respawn_radius.deactivate_respawn_radius()
	collision_layer += pow(2, 2-1)
	ammo_bar.update_ammo_bar(item_manager.return_ammo_count())
