extends "res://src/environment/objects/doors/base_door/BaseDoor.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

@onready var interaction_zone = $InteractionZone

@export var unlock_amount = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	turn_off_entrance()
	interaction_zone.connect("hint", Callable(self, "show_hint"))
	

func show_hint():
	$Hint.visible = true
	if Burglar.stealth_points >= unlock_amount:
		turn_on_entrance()
		interaction_zone.turn_off()
		
func turn_on_entrance():
	interact_back.monitoring = true
	interact_back.monitorable = true
	interact_front.monitoring = true
	interact_front.monitorable = true

func turn_off_entrance():
	interact_back.monitoring = false
	interact_back.monitorable = false
	interact_front.monitoring = false
	interact_front.monitorable = false
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
