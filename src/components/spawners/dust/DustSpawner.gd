extends Marker2D

signal dust_effect

# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("dust_effect", Callable(VFXManager, "create_dust_effect"))

func spawn_dust() -> void:
	emit_signal("dust_effect", global_position)
