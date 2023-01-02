extends Marker2D

var gun: Node2D

var EQUIP_ITEM_WEIGHTS = {
	"weapons/range/shotgun/Shotgun": 10,
	"weapons/range/minigun/Minigun": 5,
	"weapons/range/revolver/Revolver": 20
#	"weapons/range/rocket_launcher/RocketLauncher": 1
}

var ITEM_POSITIONS = {
	"MINIGUN": Vector2(24, 5),
	"SHOTGUN": Vector2(28, 5),
	"REVOLVER": Vector2(35, 3),
	"RPG":Vector2(28, 6)
}

func normalize_item_weights():
	var sum = 0
	# force multiplier to be a float
	var multiplier = 1.0
	for key in EQUIP_ITEM_WEIGHTS:
		sum += round(EQUIP_ITEM_WEIGHTS[key])
	# if our sum is greater than 100 then we want then find the
	# multiplier that will bring it close to 100
	if sum > 100:
		multiplier = 100/sum

	for key in EQUIP_ITEM_WEIGHTS:
		# First do the multiplier
		EQUIP_ITEM_WEIGHTS[key] = multiplier * float(EQUIP_ITEM_WEIGHTS[key])
		# if rounding it will make it zero (i.e. it was .4) then make it 1
		if EQUIP_ITEM_WEIGHTS[key] > 0 && round(EQUIP_ITEM_WEIGHTS[key]) == 0:
			EQUIP_ITEM_WEIGHTS[key] = 1
		else:
			EQUIP_ITEM_WEIGHTS[key] = round(EQUIP_ITEM_WEIGHTS[key])

func choose_weapon():
	var drop_list = []
	for key in EQUIP_ITEM_WEIGHTS:
		for _i in range(EQUIP_ITEM_WEIGHTS[key]):
			drop_list.append(key)

	# index is a number between 0 and list size - 1
	var index = randi() % drop_list.size()
	# load the scene at index
	var scene = str("res://src/entities/items/", drop_list[index], ".tscn")
	
	gun = load(scene).instantiate()
	gun.global_position = ITEM_POSITIONS[gun.entity_name]
	
	
func add_weapon():
	add_child(gun)
	gun.cancel_despawn()
	gun.ammo = 0
	if gun.entity_name == "RPG":
		return
	gun.bullet_spawner.can_hit_players = true
	gun.bullet_spawner.can_hit_enemies = false

func _ready():
	normalize_item_weights()
	choose_weapon()
	add_weapon()

func shoot():
	if gun == null:
		return
	gun.shoot()

func delete_gun():
	gun.queue_free()

func init(set_parent: Node2D):
	gun.init(set_parent)
	
