extends Control

@export var trigger_game_over_when_caught = true

signal game_over

@onready var score = $Score

func _ready():
	if !trigger_game_over_when_caught:
		visible = false
	
	score.text = "[center]x" + str(Burglar.stealth_points)
	
	Burglar.connect("update_alert_count",Callable(self,"update_alert_count"))
	connect("game_over", Callable(Burglar, "start_game_over"))
	connect("game_over", Callable(Global.UI_layer, "hide_ui"))


func update_alert_count():
	if Burglar.alert_counter >= 3 && trigger_game_over_when_caught:
		emit_signal("game_over")
	var children = get_children()
	for i in range(0, min(Burglar.alert_counter, 3)):
		children[i].frame = 1
	
