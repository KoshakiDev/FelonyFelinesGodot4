extends "res://src/components/effects/base_effect/Effect.gd"

var random_direction_vector: Vector2
var speed = randi_range(3, 5)
@onready var timer = $Timer

func _ready():
	super._ready()
	anim_player.play("Animate")
	random_direction_vector = Vector2(randf_range(0.0, 1.0), randf_range(0.0, 1.0))
	timer.connect("timeout", Callable(self, "stop_speed"))

func _physics_process(delta):
	position += random_direction_vector * speed
	if speed > 0:
		speed -= 0.01

func stop_speed():
	speed = 0
