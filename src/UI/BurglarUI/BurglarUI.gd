extends Control

@onready var alert_time_left = $AlertTimeLeft

func _ready():
	print(alert_time_left)
	Burglar.set("alert_time_left", alert_time_left)
	Burglar.connect("update_alert_count",Callable(self,"update_alert_count"))

func update_alert_count():
	var children = get_children()
	for i in range(0, min(Burglar.alert_counter, 5)):
		children[i].frame = 1
