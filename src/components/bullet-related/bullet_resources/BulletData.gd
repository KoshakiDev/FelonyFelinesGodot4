extends Resource
class_name BulletData

var bullet_owner: Node2D

var spawn_position: Vector2

var sprite_y: float = 0.0

var direction: Vector2 = Vector2.RIGHT

@export var speed: float = 1.0

@export var hitbox_data: HitboxData

@export var can_hit_enemies: bool = false

@export var can_hit_players: bool = false

@export var can_hit_projectiles: bool = false

func set_bullet_owner(new_bullet_owner: Node2D):
	bullet_owner = new_bullet_owner

func set_spawn_position(new_spawn_position: Vector2):
	spawn_position = new_spawn_position

func set_sprite_y(new_sprite_y: float):
	sprite_y = new_sprite_y

func set_direction(new_direction: Vector2):
	direction = new_direction
