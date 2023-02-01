extends CanvasLayer

#THIS IS FOR THE BURGLAR WORLD

func _ready():
	visible = true
	Global.set("UI_layer", self)

func hide_ui():
	$BurglarUI.visible = false

func set_vignette_visibility(visibility):
	var tween = create_tween()
	if visibility:
		tween.tween_property(
			$Vignette.material, 
			"shader_parameter/vignette_intensity", 
			1.0, 0.2)
	else:
		tween.tween_property(
			$Vignette.material, 
			"shader_parameter/vignette_intensity", 
			0.0, 0.2)
	
