extends RigidBody2D


var is_dead: bool = false
var is_grabbing: bool = false

@export var force_strength: float = 5000

@onready var player := get_tree().get_first_node_in_group("Player")
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if not is_dead and not is_grabbing:
		var force_direction: Vector2 = Vector2.ZERO
		# Look at and move toward player until enemy passes player
		if player != null and player.global_position.y > global_position.y:
			force_direction = global_position.direction_to(player.global_position)
		
		var force_vector: Vector2 = force_direction * force_strength

		apply_force(force_vector * delta)


func _process(delta: float) -> void:
	# Ensure player is still in the scene
	player = get_tree().get_first_node_in_group("Player")
	
	if is_grabbing and player != null:
		global_position.x = player.global_position.x - 50
		global_position.y = player.global_position.y

  
func _on_body_entered(body: Node) -> void:
	die()


func die() -> void:
	is_dead = true
	is_grabbing = false


func _on_grab_area_area_entered(area: Area2D) -> void:
	if area.name == "GrabArea":
		is_grabbing = true
