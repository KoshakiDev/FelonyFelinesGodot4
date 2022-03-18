extends "res://src/entities/entityModules.gd"

onready var state_machine := $StateMachine

onready var health_bar := $HealthBar

onready var animation_machine := $AnimationMachine

onready var hitbox := $Hitbox
onready var engage_range := $EngageRange

onready var collision := $CollisionShape2D

onready var sprite := $Sprite

onready var hurtbox = $Hurtbox

export var damage_value: float = 10
export var knockback_value: float = 20

func _ready():
	_initialize_health_bar(health_bar)
	hurtbox.connect("area_entered", self, "_on_Hurtbox_area_entered")
	engage_range.connect("body_entered", self, "_on_EngageRange_body_entered")
	engage_range.connect("body_exited", self, "_on_EngageRange_body_exited")
