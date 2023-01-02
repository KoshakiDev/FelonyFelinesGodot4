extends Control


@onready var anim_player = $AnimationPlayer

func _ready():
	VFXManager.connect("create_shockwave_effect", 
		Callable(self, "create_shockwave"))

func create_shockwave():
	anim_player.play("shockwave")
	await anim_player.animation_finished
	
