extends RigidBody2D


var is_dead: bool = false
var is_grabbing: bool = false

@export var force_strength: float = 5000
@export var player_grab_offset: float = 50

@onready var player := get_tree().get_first_node_in_group("Player")
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var death_sound_player: AudioStreamPlayer = %DeathSoundPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	grab_player()
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

  
func _on_body_entered(body: Node) -> void:
	die()


func die() -> void:
	if not death_sound_player.is_playing():
		death_sound_player.play()
	is_dead = true
	is_grabbing = false


func _on_grab_area_area_entered(area: Area2D) -> void:
	if area.name == "GrabArea" and not is_dead:
		is_grabbing = true


func grab_player() -> void:
	if not is_dead and is_grabbing and player:
		player.grabbed_meter += player.grab_strength
		if global_position.x >= player.global_position.x:
			global_position.x = player.global_position.x + player_grab_offset
			rotation = PI / 2
		else:
			global_position.x = player.global_position.x - player_grab_offset
			rotation = 3 * PI / 2
		global_position.y = player.global_position.y
		
		if player and player.grabbed_meter <= 0:
			die()
