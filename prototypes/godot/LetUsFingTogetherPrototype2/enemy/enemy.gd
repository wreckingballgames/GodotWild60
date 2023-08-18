class_name Enemy
extends RigidBody2D


var is_dead: bool = false
var is_grabbing: bool = false

@export var force_strength: float = 5000
@export var player_grab_offset: float = 40

@onready var player: Player = get_tree().get_first_node_in_group("Player")
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var death_sound_player: AudioStreamPlayer = %DeathSoundPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D


func _ready() -> void:
	collision_shape_2d.disabled = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	player = get_tree().get_first_node_in_group("Player")
	grab_player()
	if not is_dead and not is_grabbing:
		var force_direction: Vector2 = Vector2.ZERO
		# Look at and move toward player until enemy passes player
		if player and player.global_position.y > global_position.y:
			force_direction = global_position.direction_to(player.global_position)
		
		var force_vector: Vector2 = force_direction * force_strength

		apply_force(force_vector * delta)

  
func _on_body_entered(body: Node) -> void:
	die()


func die() -> void:
	if not is_dead:
		death_sound_player.play()
		is_dead = true
		is_grabbing = false


func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.name == "FingerArea" and not is_dead:
		die()
	if area.name == "GrabArea" and not is_dead:
		is_grabbing = true


func grab_player() -> void:
	if not is_dead and is_grabbing and player:
		player.grabbed_meter += player.grab_strength # Can I move this back to Player now that grabbed_meter zeros out properly?
		if global_position.x >= player.global_position.x:
			global_position.x = player.global_position.x + player_grab_offset
			rotation = PI / 2
		else:
			global_position.x = player.global_position.x - player_grab_offset
			rotation = 3 * PI / 2
		global_position.y = player.global_position.y
		
		if player and player.grabbed_meter < 0:
			die()


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	collision_shape_2d.disabled = false
