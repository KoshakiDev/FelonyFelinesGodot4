@tool
class_name BulletSpawner
extends Marker2D

# Called whenever a shot is ready and shooting is false
signal shot_ready()
signal shot_fired()

# Scene to use as a bullet, it's script needs to extend Bullet
@export var bullet_scene: PackedScene
# time between shots
@export var shot_delay: float = .1

# speed of the emitted bullets
@export var bullet_speed: float = 400
@export var bullet_damage_value = 5
@export var knockback_value = 20
@export var shoot_anim_player_p: NodePath

# the emitter to be used for spawning bullets (controls behaviour)
var bullet_emitter: BulletEmitter

# offset to the rotation, added to BulletSpawners rotation
var rotation_offset: float = 0.0

var can_shoot: bool = true

var shoot_anim_player: AnimationPlayer

var timer: Timer

var can_hit_players = false
var can_hit_enemies = false

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	setup_animation_player()
	setup_shot_delay_timer()
	if !bullet_emitter:
		printerr("emitter in BulletSpawner is not a BulletEmitter!")
		queue_free()
	bullet_emitter.bullet_spawner_reference = self

func setup_animation_player():
	if shoot_anim_player_p != NodePath():
		shoot_anim_player = get_node(shoot_anim_player_p)
		if not shoot_anim_player.has_animation("Shoot"):
			printerr("Weapon %s does not have a valid Shoot animation in %s"
				% [owner.name, shoot_anim_player_p])
			return
		var anim_length := shoot_anim_player.get_animation("Shoot").length / shoot_anim_player.playback_speed
		if shot_delay < anim_length:
			# TODO: Don't use the shot delay checked a timer, use the animation ending
			# signal instead.
			# Adjust the shot delay if it does not fit in the animation with a small buffer
			shot_delay = anim_length + .0001
			printerr("The shot delay in %s is to short for the animation length. It was adujusted from %s to %s"
				% [owner.name, shot_delay, anim_length])
	

func setup_shot_delay_timer():
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = shot_delay
	timer.one_shot = true
	timer.autostart = false
	timer.connect("timeout",Callable(self,"reload_timer_finished"))

func reload_timer_finished():
	can_shoot = true

func shoot() -> void:
	if !can_shoot:
		return
	var shoot_direction = Vector2.RIGHT.rotated(global_rotation + rotation_offset).normalized()
	
	var bullet_instance = bullet_scene.instantiate()
	
	bullet_instance.setup(
		global_position,
		shoot_direction, 
		bullet_speed, 
		bullet_damage_value, 
		knockback_value,
		can_hit_enemies,
		can_hit_players)
		
	bullet_emitter.shoot(bullet_instance, bullet_scene)
	emit_signal("shot_fired")
	timer.start()
	can_shoot = false
	

# Workaround for resource list
func _get_property_list() -> Array:
	var exported_resource_property: Dictionary = {
		"name":"bullet_emitter",
		"type":TYPE_OBJECT,
		"hint":PROPERTY_HINT_RESOURCE_TYPE,
		"hint_string": "BulletEmitter",
		"usage": PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE
		}
	return [exported_resource_property]
