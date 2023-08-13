extends RigidBody2D


var is_dead: bool = false

@export var rotate_speed: float = .01
@export var scroll_speed: float = 2000

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var scroll_vector: Vector2 = Vector2.DOWN * scroll_speed
@onready var rng := RandomNumberGenerator.new()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rng.randomize()
	sprite_2d.global_rotation = rng.randf_range(0, TAU)


func _physics_process(delta: float) -> void:
	apply_force(scroll_vector * delta)


func _process(delta: float) -> void:
	sprite_2d.rotate(rotate_speed)
