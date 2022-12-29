extends Area2D

@onready var anim_player = $AnimationPlayer
#@onready var progress_sprite := $SpriteContainer/ProgressSprite

@onready var circle_progress = $CircleProgress

@export var respawn_time = 2.5


func _ready():
	deactivate_respawn_radius()
	circle_progress.setup_timer(respawn_time)
	#progress_sprite.material = progress_sprite.material.duplicate()


func activate_respawn_radius():
	monitoring = true
	visible = true
	anim_player.play("Not Healing")
	circle_progress.reset_progress()
	circle_progress.setup_timer(respawn_time)

func deactivate_respawn_radius():
	monitoring = false
	visible = false

	
func _on_RespawnTimer_timeout():
	deactivate_respawn_radius()
	owner.respawn_player()

func _on_Respawn_body_entered(body):
	if owner == body:
		return
	if not body.is_in_group("PLAYER"):
		return
	if body.health_manager.is_dead():
		return
	circle_progress.start()
	anim_player.play("Healing")
	
func _on_Respawn_body_exited(body):
	if owner == body:
		return
	if not body.is_in_group("PLAYER"):
		return
	if body.health_manager.is_dead():
		return
	circle_progress.stop()
	anim_player.play("Not Healing")
