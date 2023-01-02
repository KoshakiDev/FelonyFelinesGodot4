extends Control

@onready var alert_time_left = $AlertTimeLeft

signal game_over

func _ready():
#	print(alert_time_left)
	Burglar.set("alert_time_left", alert_time_left)
	Burglar.connect("update_alert_count",Callable(self,"update_alert_count"))
	connect("game_over", Callable(Burglar, "start_game_over"))

func update_alert_count():
	if Burglar.alert_counter >= 6:
		emit_signal("game_over")
	var children = get_children()
	for i in range(0, min(Burglar.alert_counter, 6)):
		children[i].frame = 1
	
