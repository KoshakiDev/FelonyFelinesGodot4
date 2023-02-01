extends "res://src/entities/items/base_templates/base_item/base_item.gd"

@export_group("Melee Settings")
@export var recoil: float = 15
@export var attack_delay: float = 0.5

@onready var hitbox = $Marker2D/Visuals/Sprite2D/Hitbox

var timer: Timer

var can_attack = true

func _ready():
	super._ready()
	#animation_machine.play_animation("Idle", "AnimationPlayer")
	hitbox.turn_on()
	setup_attack_delay_timer()

func set_inactive():
	super.set_inactive()
	hitbox.turn_off()

func init(set_item_owner: Node2D) -> void:
	super.init(set_item_owner)
	hitbox.hitbox_owner = item_owner

func setup_attack_delay_timer():
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = attack_delay
	timer.one_shot = true
	timer.autostart = false
	timer.connect("timeout",Callable(self,"reload_timer_finished"))

func is_empty():
	super.is_empty()
	return false

func reload_timer_finished():
	can_attack = true

func action()-> void:
	if !can_attack:
		return
	animation_machine.play_animation("Attack", "AnimationPlayer")
	
	if item_owner.has_method("apply_external_force"):
		item_owner.apply_external_force(-1 * item_owner.internal_forces, recoil) 
	
	sound_machine.play_sound("Swoosh")
	Shake.shake(2.5, .5)
	timer.start()
	can_attack = false

