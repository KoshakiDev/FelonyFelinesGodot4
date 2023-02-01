extends "res://src/components/effects/base_effect/Effect.gd"

var effects_path = [
	"res://test/PNG Spritesheets/big2_100x100px.png",
	"res://test/PNG Spritesheets/big3_100x100px.png",
	"res://test/PNG Spritesheets/big4_100x100px.png",
	"res://test/PNG Spritesheets/big_100x100px.png",
	"res://test/PNG Spritesheets/big_directional2_100x100px.png",
	"res://test/PNG Spritesheets/big_directional3_100x100px.png",
	"res://test/PNG Spritesheets/big_directional4_100x100px.png",
	"res://test/PNG Spritesheets/big_directional_100x100px.png",
	"res://test/PNG Spritesheets/clean2_100x100px.png",
	"res://test/PNG Spritesheets/clean3_100x100px.png",
	"res://test/PNG Spritesheets/clean4_100x100px.png",
	"res://test/PNG Spritesheets/clean_100x100px.png",
	"res://test/PNG Spritesheets/clean_directional2_100x100px.png",
	"res://test/PNG Spritesheets/clean_directional3_100x100px.png",
	"res://test/PNG Spritesheets/clean_directional4_100x100px.png",
	"res://test/PNG Spritesheets/clean_directional_100x100px.png"
];

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D.set_texture(load(effects_path[randi_range(0, effects_path.size() - 1)]))
	super._ready()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
