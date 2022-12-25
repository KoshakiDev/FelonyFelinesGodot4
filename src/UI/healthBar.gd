extends TextureProgressBar

#THIS ONLY CONTROLS THE REPRESENTATION, THERE IS ALSO HEALTH IN THE ENTITY MODULE

@onready var animation_player = $AnimationPlayer

@export var gradient: Gradient

func _ready():
	tint_progress = gradient.sample(ratio)

func _on_value_changed(_new_value):
	tint_progress = gradient.sample(ratio)

func set_value(new_value):
	animation_player.play("twinkle")
	var duration = animation_player.current_animation_length
	var tween = create_tween()
	tween.tween_property(self, "value", new_value, duration)

func turn_off():
	visible = false

func turn_on():
	visible = true
