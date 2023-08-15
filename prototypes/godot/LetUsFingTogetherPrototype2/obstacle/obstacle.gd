extends RigidBody2D


var is_dead: bool = false

@export var rotate_speed: float = .01

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var rng := RandomNumberGenerator.new()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rng.randomize()
	sprite_2d.global_rotation = rng.randf_range(0, TAU)


func _process(delta: float) -> void:
	sprite_2d.rotate(rotate_speed)
