extends RigidBody2D


@export var force_strength: float = 100

@onready var player := get_tree().get_nodes_in_group("Player")[0]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var force_direction: Vector2 = Vector2.ZERO
	if player:
		look_at(player.global_position)
		force_direction = global_position.direction_to(player.global_position)
	
	var force_vector: Vector2 = force_direction * force_strength

	apply_force(force_vector)
	
	var screen_position: Vector2 = get_viewport_rect().position
	var screen_end: Vector2 = get_viewport_rect().end
	if global_position.x < screen_position.x or global_position.x > screen_end.x:
		die()
	if global_position.y < screen_position.y or global_position.y > screen_end.y:
		die()



func _process(delta: float) -> void:
	player = get_tree().get_nodes_in_group("Player")[0]
#	if global_position.x < 


func die() -> void:
	queue_free()
