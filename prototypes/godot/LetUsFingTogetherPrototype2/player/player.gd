extends CharacterBody2D


var can_die: bool = true

# Grab Mechanic Members
var is_grabbed: bool = false
var grabbed_meter: float = 0

# Designer Members
@export var speed: float = 60
@export var lives: int = 3
@export var flick_force: float = 2500
@export var shake_off_strength: float = 0.03
@export var grab_strength: float = 0.0060

@onready var starting_position: Vector2 = global_position

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

@onready var shoot_sound_player: AudioStreamPlayer = %ShootSoundPlayer
@onready var death_sound_player: AudioStreamPlayer = %DeathSoundPlayer
@onready var flick_sound_player: AudioStreamPlayer = %FlickSoundPlayer


func _physics_process(delta: float) -> void:	
	var input_axis := get_movement_input()
	velocity.x = input_axis * speed # Remember that move_and_slide() applies delta
	
	move_and_slide()
	
	bounds_checking()
	handle_flick_input()


func _process(delta: float) -> void:
	debug_restart()
	debug_toggle_can_die()
	debug_decrement_lives()
	debug_increment_lives()
	
	get_grabbed()


func get_movement_input() -> float:
	return Input.get_axis("move_left", "move_right")


func bounds_checking() -> void:
	#Screen bounds checking
	var screen_size := get_viewport_rect().size
	if global_position.x < 0:
		global_position.x = 0
	elif global_position.x > screen_size.x:
		global_position.x = screen_size.x


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
	if body.get_collision_layer_value(3) and body.is_dead == true:
		return
	die()


func die() -> void:
	if can_die:
		lives -= 1
		death_sound_player.play()
		if lives <= 0:
			queue_free()
			return
		global_position = starting_position
		grabbed_meter = 0


func _on_finger_area_body_entered(body: Node2D) -> void:
	flick(body)


func flick(body: Node2D) -> void:
	# Use RigidBody2Ds for enemies and obstacles
	var flick_vector: Vector2 = global_position.direction_to(body.global_position) * flick_force
	body.apply_impulse(flick_vector)
	flick_sound_player.play()


func shake_off() -> void:
	if grabbed_meter > 0:
		grabbed_meter -= shake_off_strength
	else:
		is_grabbed = false


func get_grabbed() -> void:
	if grabbed_meter >= 1:
		die()
		return
	if is_grabbed:
		grabbed_meter += grab_strength


func _on_grab_area_body_entered(body: Node2D) -> void:
	if body.get_collision_layer_value(3):
		is_grabbed = true


func debug_restart() -> void:
	if Input.is_action_just_pressed("debug_restart"):
		get_tree().reload_current_scene()


func debug_increment_lives() -> void:
	if Input.is_action_just_pressed("debug_increment_lives"):
		lives += 1
		print(lives)


func debug_decrement_lives() -> void:
	if Input.is_action_just_pressed("debug_decrement_lives"):
		die()
		print(lives)


func debug_toggle_can_die() -> void:
	if Input.is_action_just_pressed("debug_toggle_can_die"):
		can_die = (not can_die)
		print("can_die?")
		print(can_die)
