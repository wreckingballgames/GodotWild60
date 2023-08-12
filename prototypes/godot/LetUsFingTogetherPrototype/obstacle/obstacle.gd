extends RigidBody2D


var is_dead: bool = false

@export var starting_rotation: float = 0
@export var rotate_speed: float = .01
@export var scroll_speed: float = 4000

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var scroll_vector: Vector2 = Vector2.LEFT * scroll_speed
@onready var rng := RandomNumberGenerator.new()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rng.randomize()
	starting_rotation = rng.randf_range(0, 7)
	sprite_2d.global_rotation = starting_rotation


func _physics_process(delta: float) -> void:
	apply_force(scroll_vector * delta)


func _process(delta: float) -> void:
	sprite_2d.rotate(rotate_speed)
