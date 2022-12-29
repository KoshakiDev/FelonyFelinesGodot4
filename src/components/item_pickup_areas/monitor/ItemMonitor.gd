extends Area2D

signal add_item_to_inventory(item)

func _ready():
	monitoring = true
	monitorable = false
	connect("area_entered", Callable(self, "pick_up_detected_item"))

func pick_up_detected_item(area):
	var item = area.owner
	emit_signal("add_item_to_inventory", item)
