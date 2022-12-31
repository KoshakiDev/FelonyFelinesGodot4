extends Control

@onready var timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	Burglar.connect("show_busted_screen", Callable(self, "start_timer"))
	timer.connect("timeout", Callable(Burglar, "game_over"))

func start_timer():
	visible = true
	timer.start()
