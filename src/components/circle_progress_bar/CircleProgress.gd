extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
@onready var progress_sprite = $ProgressSprite
@onready var timer = $Timer

func _ready():
	pass
	
# Called when the node enters the scene tree for the first time.
func _physics_process(_delta: float) -> void:
	progress_sprite.material.set_shader_parameter("progress", 1.0 - timer.time_left / timer.wait_time)

func reset_progress():
	progress_sprite.material.set_shader_parameter("progress", 0)
	

func setup_timer(set_wait_time):
	timer.wait_time = set_wait_time
	timer.one_shot = true
	timer.autostart = false

func start():
	timer.start()

func stop():
	timer.stop()
