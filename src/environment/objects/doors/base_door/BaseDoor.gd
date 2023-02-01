extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
@onready var interact_front = $InteractFront
@onready var interact_back = $InteractBack

@onready var door_collider = $Door

var player: Node2D

var is_door_open = false

# Called when the node enters the scene tree for the first time.
func _ready():
	interact_back.connect("body_entered",Callable(self,"target_found"))
	interact_front.connect("body_entered",Callable(self,"target_found"))
	interact_back.connect("body_exited",Callable(self,"target_lost"))
	interact_front.connect("body_exited",Callable(self,"target_lost"))

func _input(event):
	if player == null:
		return
	if event.is_action_pressed("action" + player.player_id):
		interact_with_door()

func interact_with_door():
	if is_door_open:
		close()
	else:
		open()

func target_lost(body):
	player = null

func target_found(body):
	player = body

func close():
	door_collider.shape.size.x = 48
	door_collider.global_position.x -= 48
	$Sprite2D.frame = 0
	is_door_open = false


func open():
	door_collider.shape.size.x = 0
	door_collider.global_position.x += 48
	$Sprite2D.frame = 1
	is_door_open = true



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
