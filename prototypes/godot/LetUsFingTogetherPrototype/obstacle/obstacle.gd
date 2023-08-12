extends RigidBody2D


var is_dead: bool = false

@export var starting_rotation: float = 0
@export var rotate_speed: float = .01
@export var scroll_speed: float = 4000

@onready var scroll_vector: Vector2 = Vector2.LEFT * scroll_speed
@onready var rng := RandomNumberGenerator.new()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rng.randomize()
	starting_rotation = rng.randf_range(0, 7)
	global_rotation = starting_rotation


func _physics_process(delta: float) -> void:
	rotate(rotate_speed)
	apply_force(scroll_vector * delta)
