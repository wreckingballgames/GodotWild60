extends CharacterBody2D


@export var speed: float = 250
@export var health: int = 3
@export var lives: int = 3

@onready var pinky_finger_collision: CollisionShape2D = $PinkyFingerCollision
@onready var ring_finger_collision: CollisionShape2D = $RingFingerCollision
@onready var middle_finger_collision: CollisionShape2D = $MiddleFingerCollision
@onready var index_finger_collision: CollisionShape2D = $IndexFingerCollision
@onready var thumb_collision: CollisionShape2D = $ThumbCollision



func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	var movement_axis := get_movement_input()
	velocity.y = movement_axis * speed
	
	move_and_slide()
	
	handle_flicking()


func get_movement_input() -> float:
	return Input.get_axis("move_up", "move_down")


func handle_flicking() -> void:
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
		
	if Input.is_action_just_released("flick_pinky_finger"):
		pinky_finger_collision.set_deferred("disabled", true)
		# Animate pinky finger sprite in reverse, set at first frame
	if Input.is_action_just_released("flick_ring_finger"):
		ring_finger_collision.set_deferred("disabled", true)
		# Animate ring finger sprite in reverse, set at first frame
	if Input.is_action_just_released("flick_middle_finger"):
		middle_finger_collision.set_deferred("disabled", true)
		# Animate pinky finger sprite in reverse, set at final frame
	if Input.is_action_just_released("flick_index_finger"):
		index_finger_collision.set_deferred("disabled", true)
		# Animate index finger sprite in reverse, set at final frame
	if Input.is_action_just_released("flick_thumb"):
		thumb_collision.set_deferred("disabled", true)
		# Animate thumb sprite in reverse, set at final frame


func _on_hurtbox_area_entered(area: Area2D) -> void:
	take_damage()


func take_damage() -> void:
	health -= 1
	if health <= 0:
		die()


func die() -> void:
	queue_free()
