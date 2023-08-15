extends RigidBody2D


var is_dead: bool = false

@export var rotate_speed: float = .01

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var rng := RandomNumberGenerator.new()
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rng.randomize()
	sprite_2d.global_rotation = rng.randf_range(0, TAU)
	collision_shape_2d.disabled = true


func _process(delta: float) -> void:
	sprite_2d.rotate(rotate_speed)


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	collision_shape_2d.disabled = false
