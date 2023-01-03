extends "res://src/entities/base_templates/base_entity/base_entity.gd"

@export var player_id = "_1"
const red_sprite = preload("res://assets/entities/players/red_brother_sheet_96x96.png")
const blue_sprite = preload("res://assets/entities/players/Blue_Movement_Coloring-Sheet.png")
const blue_sprite_dark = preload("res://assets/entities/players/Blue_Movement_Coloring_Dark-Sheet.png")

@onready var inventory_position = $Visuals/Sprite2D/InventoryPosition
@onready var item_manager := $Visuals/Sprite2D/InventoryPosition/ItemManager
@onready var item_monitor := $Areas/ItemMonitor

@onready var respawn_radius = $Areas/Respawn

@onready var ammo_bar = $AmmoBar

var player_visual_middle = Vector2(0, -50)


signal player_died

var interacting = false

func _ready():
	$Camera.current = true
	super._ready()
	setup_player()
	setup_burglar_mode()
	item_manager.init(self, ammo_bar)
	item_monitor.connect("add_item_to_inventory", 
		Callable(item_manager, "add_item"))

func setup_burglar_mode():
	connect("player_died", Callable(Burglar, "start_game_over"))

func setup_player():
	if player_id == "_2":
		$HealthBar.position.y = -85 + 10
		inventory_position.position.y += 10
		sprite.set_texture(red_sprite)
		player_visual_middle = Vector2(0, -50 + 10)
		listener.current = true;
	
	elif player_id == "_1":
		$HealthBar.position.y = -85
		inventory_position.position.y += 0
		sprite.set_texture(blue_sprite)
		player_visual_middle = Vector2(0, -50)
	#Global.set("brother" + player_id, self)
	#connect("player_died",Callable(Global,"player_died"))

func adjust_rotation_to_direction(direction):
	super.adjust_rotation_to_direction(direction)
	if visuals.scale.x == -1:
		item_manager.rotation = PI - direction.angle()
	elif visuals.scale.x == 1:
		item_manager.rotation = direction.angle()
	#item_manager.look_at(item_manager.global_position + direction)

func _physics_process(_delta):
	#item_manager.get_total_weight() 
	total_mass = mass
	if item_manager.cur_item != null:
		total_mass += item_manager.cur_item.item_mass
	if get_collision_layer_value(10):
		sprite.set_texture(blue_sprite)
	else:
		sprite.set_texture(blue_sprite_dark)
	
	super._physics_process(_delta)
	#print(item_manager.rotation, " ", visuals.scale.x)

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
