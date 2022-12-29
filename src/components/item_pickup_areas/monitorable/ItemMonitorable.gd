extends Area2D

@export var delete_pickup_range = false
@onready var anim_player = $AnimationPlayer
@onready var despawn_timer = $DespawnTimer
signal despawn

func _ready():
	monitoring = false
	monitorable = true
	if delete_pickup_range:
		queue_free()
	anim_player.play("Animate")
	connect("area_entered", Callable(self, "delete_self"))

func delete_self(_area):
	queue_free()

func setup_timer(wait_time):
	despawn_timer.connect("timeout", Callable(self, "timeout"))	
	despawn_timer.one_shot = true
	despawn_timer.wait_time = wait_time
	despawn_timer.start()
	
func timeout():
	emit_signal("despawn")

