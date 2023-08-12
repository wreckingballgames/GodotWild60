extends RigidBody2D


var is_dead: bool = false

@export var force_strength: float = 5000

@onready var player := get_tree().get_first_node_in_group("Player")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if not is_dead:
		var force_direction: Vector2 = Vector2.ZERO
		# Look at and move toward player until enemy passes player
		if player and player.global_position.x < global_position.x:
			look_at(player.global_position)
			force_direction = global_position.direction_to(player.global_position)
		
		var force_vector: Vector2 = force_direction * force_strength

		apply_force(force_vector * delta)


func _process(delta: float) -> void:
	# Ensure player is still in the scene
	player = get_tree().get_first_node_in_group("Player")


func _on_body_entered(body: Node) -> void:
	is_dead = true
