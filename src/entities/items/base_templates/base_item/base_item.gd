extends Node2D

@export_group("Item Variables")
@export var entity_type = "ITEM"
@export var item_type = "WEAPON"
@export var entity_name = "NAME"

@export var despawnable: bool = true
@export var despawn_time: int = 5

@onready var state_machine = $Marker2D/StateMachine
@onready var item_pickup_area = $Marker2D/PickUpRange
@onready var sprite = $Marker2D/Visuals/Sprite2D
@onready var animation_machine = $Marker2D/AnimationMachine
@onready var sound_machine = $Marker2D/SoundMachine

func _ready():
	sound_machine.play_sound("ItemDrop")
	#item_pickup_area.connect("area_entered", Callable(self, "pickup_item"))
	item_pickup_area.connect("despawn", Callable(self, "despawn"))
	if despawnable:
		item_pickup_area.setup_timer(despawn_time)
	
var item_owner: Node2D
var player_id = ""

func init(set_owner: Node2D) -> void:
	self.item_owner = set_owner
	if item_owner.get("player_id") != null:
		player_id = item_owner.player_id
	
	
#To-do: the pickup item area does not work for some reason inside the base range weapon
func pickup_item():
	print("despawn cancelled")
	cancel_despawn()
	sound_machine.play_sound("Pickup")

func set_inactive():
	visible = false
	state_machine.transition_to("Disabled")
	#print("set inactive")
	
func set_active():
	visible = true
	state_machine.transition_to("Idle")
	#print("set active")
	
func despawn():
	print("I was despawned")
	queue_free()

func cancel_despawn():
	item_pickup_area.queue_free()
