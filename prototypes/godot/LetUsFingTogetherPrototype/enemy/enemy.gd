extends RigidBody2D


@export var force_strength: float = 50

@onready var player := get_tree().get_nodes_in_group("Player")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var force_direction: Vector2 = Vector2.ZERO
	# Look at and move toward player until enemy passes player
	if player.size() != 0 and player[0].global_position.x < global_position.x:
		look_at(player[0].global_position)
		force_direction = global_position.direction_to(player[0].global_position)
	
	var force_vector: Vector2 = force_direction * force_strength

	apply_force(force_vector)


func _process(delta: float) -> void:
	# Ensure player is still in the scene
	player = get_tree().get_nodes_in_group("Player")
	
	# Check if out of bounds, tell die() to free enemy if so
	var screen_position: Vector2 = get_viewport_rect().position
	var screen_end: Vector2 = get_viewport_rect().end
	if global_position.x < screen_position.x or global_position.x > screen_end.x:
		die(true)
	if global_position.y < screen_position.y or global_position.y > screen_end.y:
		die(true)


func _on_body_entered(body: Node) -> void:
	die(false)


func die(is_offscreen: bool) -> void:
	if is_offscreen:
		queue_free()

