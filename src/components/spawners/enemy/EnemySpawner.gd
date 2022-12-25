extends Marker2D

@onready var spawn_area = $Area2D/CollisionShape2D.shape.extents

#var enemyLoad = [preload("res://src/entities/enemies/EnemyGunner/EnemyGunner.tscn"),
#			 preload("res://src/entities/enemies/EnemyBall/EnemyBall.tscn"),
#			 preload("res://src/entities/enemies/EnemyImp/EnemyImp.tscn")]

var enemyLoad = [preload("res://src/entities/enemies/EnemyGunner/EnemyGunner.tscn"),
			preload("res://src/entities/enemies/EnemyBall/EnemyBaller.tscn"),
			preload("res://src/entities/enemies/EnemyImp/EnemyImp.tscn")]


#onready var enemies = $"../Node2D"

func random_pos():
	var offset = Vector2(randf_range(-spawn_area.x, spawn_area.x), randf_range(-spawn_area.y, spawn_area.y))
	return global_position + offset

func add_enemies(count):
	randomize()
	var imp_counter = 0
	for i in range(count):
		var enemy = enemyLoad[randi() % enemyLoad.size()].instantiate()
		Global.enemies.add_child(enemy)
		enemy.global_position = random_pos()
