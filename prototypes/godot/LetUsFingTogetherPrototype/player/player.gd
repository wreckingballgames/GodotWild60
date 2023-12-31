extends CharacterBody2D


var is_grabbed: bool = false
var grabbed_meter: float = 0
var grabbing_enemies := Array()

@export var speed: float = 60
@export var lives: int = 3
@export var flick_force: float = 2500
@export var shake_off_strength: float = 0.1
@export var grab_strength: float = 0.01

@onready var starting_position: Vector2 = global_position
@onready var enemies := get_tree().get_nodes_in_group("Enemy")

# Finger collision references
@onready var pinky_finger_collision: CollisionShape2D = $FingerArea/PinkyFingerCollision
@onready var ring_finger_collision: CollisionShape2D = $FingerArea/RingFingerCollision
@onready var middle_finger_collision: CollisionShape2D = $FingerArea/MiddleFingerCollision
@onready var index_finger_collision: CollisionShape2D = $FingerArea/IndexFingerCollision
@onready var thumb_collision: CollisionShape2D = $FingerArea/ThumbCollision

# Finger sprite references
@onready var pinky_finger_sprite: Sprite2D = $FingerSprites/PinkyFingerSprite
@onready var ring_finger_sprite: Sprite2D = $FingerSprites/RingFingerSprite
@onready var middle_finger_sprite: Sprite2D = $FingerSprites/MiddleFingerSprite
@onready var index_finger_sprite: Sprite2D = $FingerSprites/IndexFingerSprite
@onready var thumb_sprite: Sprite2D = $FingerSprites/ThumbSprite


func _physics_process(delta: float) -> void:	
	var movement_axis := get_movement_input()
	velocity.y = movement_axis * speed
	
	move_and_slide()
	
	# Screen bounds checking
	var screen_size := get_viewport_rect().size
	if global_position.y < 0:
		global_position.y = 0
	elif global_position.y > screen_size.y:
		global_position.y = screen_size.y
	
	handle_flick_input()


func _process(delta: float) -> void:
	enemies = get_tree().get_nodes_in_group("Enemy")
	get_grabbed()


func get_movement_input() -> float:
	return Input.get_axis("move_up", "move_down")


func handle_flick_input() -> void:
	# Flick
	if Input.is_action_just_pressed("flick_pinky_finger"):
		pinky_finger_collision.set_deferred("disabled", false)
		# Animate pinky finger sprite, set at final frame
	if Input.is_action_just_pressed("flick_ring_finger"):
		ring_finger_collision.set_deferred("disabled", false)
		# Animate ring finger sprite, set at final frame
	if Input.is_action_just_pressed("flick_middle_finger"):
		middle_finger_collision.set_deferred("disabled", false)
		# Animate pinky finger sprite, set at final frame
	if Input.is_action_just_pressed("flick_index_finger"):
		index_finger_collision.set_deferred("disabled", false)
		# Animate index finger sprite, set at final frame
	if Input.is_action_just_pressed("flick_thumb"):
		thumb_collision.set_deferred("disabled", false)
		# Animate thumb sprite, set at final frame
	
	# Release
	if Input.is_action_just_released("flick_pinky_finger"):
		pinky_finger_collision.set_deferred("disabled", true)
		shake_off()
		# Animate pinky finger sprite in reverse, set at first frame
	if Input.is_action_just_released("flick_ring_finger"):
		ring_finger_collision.set_deferred("disabled", true)
		shake_off()
		# Animate ring finger sprite in reverse, set at first frame
	if Input.is_action_just_released("flick_middle_finger"):
		middle_finger_collision.set_deferred("disabled", true)
		shake_off()
		# Animate pinky finger sprite in reverse, set at first frame
	if Input.is_action_just_released("flick_index_finger"):
		index_finger_collision.set_deferred("disabled", true)
		shake_off()
		# Animate index finger sprite in reverse, set at first frame
	if Input.is_action_just_released("flick_thumb"):
		thumb_collision.set_deferred("disabled", true)
		shake_off()
		# Animate thumb sprite in reverse, set at first frame


func _on_hurtbox_body_entered(body: Node2D) -> void:
	die()


func die() -> void:
	lives -= 1
	if lives <= 0:
		queue_free()
		return
	global_position.y = starting_position.y


func _on_finger_area_body_entered(body: Node2D) -> void:
	flick(body)


func flick(body: Node2D) -> void:
	# Use RigidBody2Ds for enemies and obstacles
	var flick_vector: Vector2 = global_position.direction_to(body.global_position) * flick_force
	body.apply_impulse(flick_vector)


func shake_off() -> void:
	if grabbed_meter > 0:
		grabbed_meter -= shake_off_strength
	else:
		is_grabbed = false
		for enemy in grabbing_enemies:
			enemy.die()
		grabbing_enemies.clear()


func get_grabbed() -> void:
	if grabbed_meter >= 1:
		die()
		return
	if is_grabbed:
		grabbed_meter += grab_strength


func _on_grab_area_body_entered(body: Node2D) -> void:
	is_grabbed = true
	grabbing_enemies.append(body)
