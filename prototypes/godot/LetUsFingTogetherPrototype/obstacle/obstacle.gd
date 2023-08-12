extends RigidBody2D


@export var starting_rotation: float = 0
@export var rotate_speed: float = .01

@onready var rng := RandomNumberGenerator.new()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rng.randomize()
	starting_rotation = rng.randf_range(0, 7)
	global_rotation = starting_rotation


func _physics_process(delta: float) -> void:
	rotate(rotate_speed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
