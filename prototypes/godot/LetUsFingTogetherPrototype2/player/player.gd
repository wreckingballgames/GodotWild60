class_name Player
extends CharacterBody2D


signal scroll_reversed


var can_die: bool = true
var can_shoot: bool = true

var rng := RandomNumberGenerator.new()

# Grab Mechanic Members
var is_grabbed: bool = false
var grabbed_meter: float = 0.1

# Designer Members

## Horizontal movement speed
@export var speed: float = 60
## Number of lives
@export var lives: int = 3
## Duration of invincibility period between deaths
@export var death_grace_period: float = 3.0
## Duration before being able to shoot again after shooting
@export var shoot_cooldown: float = 3.0
## Force applied to bodies by flicking
@export var flick_force: float = 2500
## Amount grabbed_meter is reduced by each time a finger is flicked
@export var shake_off_strength: float = 0.05
## Amount grabbed_meter is increased per frame per enemy grabbing player
@export var grab_strength: float = 0.006
## Whether or not debug keys work. See Input Map
@export var can_use_debug_keys: bool = true
## Strengh of force to apply to bullets
@export var shoot_force: float = 60000.0

@onready var starting_position: Vector2 = global_position
@onready var mouse_position: Vector2 = get_global_mouse_position()
@onready var to_mouse_vector: Vector2 = global_position.direction_to(mouse_position) * speed
@onready var death_grace_period_timer: Timer = %DeathGracePeriodTimer
@onready var shoot_cooldown_timer: Timer = %ShootCooldownTimer
@onready var shoot_vector: Vector2 = Vector2.UP * shoot_force

# Finger collision references
@onready var pinky_finger_collision: CollisionShape2D = %PinkyFingerCollision
@onready var ring_finger_collision: CollisionShape2D = %RingFingerCollision
@onready var middle_finger_collision: CollisionShape2D = %MiddleFingerCollision
@onready var index_finger_collision: CollisionShape2D = %IndexFingerCollision
@onready var thumb_collision: CollisionShape2D = %ThumbCollision

# Finger sprite references
@onready var pinky_finger_sprite: Sprite2D = %PinkyFingerSprite
@onready var ring_finger_sprite: Sprite2D = %RingFingerSprite
@onready var middle_finger_sprite: Sprite2D = %MiddleFingerSprite
@onready var index_finger_sprite: Sprite2D = %IndexFingerSprite
@onready var thumb_sprite: Sprite2D = %ThumbSprite

# Sound player references
@onready var shoot_sound_player: AudioStreamPlayer = %ShootSoundPlayer
@onready var death_sound_player: AudioStreamPlayer = %DeathSoundPlayer
@onready var flick_sound_player: AudioStreamPlayer = %FlickSoundPlayer
@onready var grab_sound_player: AudioStreamPlayer = %GrabSoundPlayer

@onready var bullet_scene := preload("res://bullet/bullet.tscn")
@onready var rocket_exhaust_sprite: Sprite2D = %RocketExhaustSprite
@onready var rocket_exhaust_is_visible: bool = true


func _physics_process(delta: float) -> void:
	to_mouse_vector = get_to_mouse_vector()
	apply_velocity()
	
	move_and_slide()
	
	bounds_checking()
	handle_flick_input()
	shoot(delta)
	get_grabbed()


func _process(delta: float) -> void:
	reverse_scroll()
	# Debug
	debug_restart()
	debug_toggle_can_die()
	debug_decrement_lives()
	debug_increment_lives()


func get_movement_input() -> float:
	return Input.get_axis("move_left", "move_right")


func apply_velocity() -> void:
#	var input_axis := get_movement_input()
#	if input_axis != 0:
#		velocity.x = input_axis * speed # Remember that move_and_slide() applies delta
#	else:
	velocity.x = to_mouse_vector.x


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
		pinky_finger_sprite.frame = 1
	if Input.is_action_just_pressed("flick_ring_finger"):
		ring_finger_collision.set_deferred("disabled", false)
		# Animate ring finger sprite, set at final frame
		ring_finger_sprite.frame = 1
	if Input.is_action_just_pressed("flick_middle_finger"):
		middle_finger_collision.set_deferred("disabled", false)
		# Animate pinky finger sprite, set at final frame
		middle_finger_sprite.frame = 1
	if Input.is_action_just_pressed("flick_index_finger"):
		index_finger_collision.set_deferred("disabled", false)
		# Animate index finger sprite, set at final frame
		index_finger_sprite.frame = 1
	if Input.is_action_just_pressed("flick_thumb"):
		thumb_collision.set_deferred("disabled", false)
		# Animate thumb sprite, set at final frame
		thumb_sprite.frame = 1
	
	# Release
	if Input.is_action_just_released("flick_pinky_finger"):
		pinky_finger_collision.set_deferred("disabled", true)
		shake_off()
		# Animate pinky finger sprite in reverse, set at first frame
		pinky_finger_sprite.frame = 0
	if Input.is_action_just_released("flick_ring_finger"):
		ring_finger_collision.set_deferred("disabled", true)
		shake_off()
		# Animate ring finger sprite in reverse, set at first frame
		ring_finger_sprite.frame = 0
	if Input.is_action_just_released("flick_middle_finger"):
		middle_finger_collision.set_deferred("disabled", true)
		shake_off()
		# Animate pinky finger sprite in reverse, set at first frame
		middle_finger_sprite.frame = 0
	if Input.is_action_just_released("flick_index_finger"):
		index_finger_collision.set_deferred("disabled", true)
		shake_off()
		# Animate index finger sprite in reverse, set at first frame
		index_finger_sprite.frame = 0
	if Input.is_action_just_released("flick_thumb"):
		thumb_collision.set_deferred("disabled", true)
		shake_off()
		# Animate thumb sprite in reverse, set at first frame
		thumb_sprite.frame = 0


func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body is Enemy and body.is_dead:
		return
	die()


func die() -> void:
	if can_die:
		lives -= 1
		death_sound_player.play()
		if lives <= 0:
			queue_free()
			return
		can_die = false
		death_grace_period_timer.start(death_grace_period)
		global_position = starting_position
		grabbed_meter = 0.1
		is_grabbed = false


func _on_finger_area_body_entered(body: Node2D) -> void:
	flick(body)


func flick(body: Node2D) -> void:
	# Use RigidBody2Ds for enemies and obstacles
	var flick_vector: Vector2 = global_position.direction_to(body.global_position) * flick_force
	body.apply_impulse(flick_vector)
	flick_sound_player.play()


func shake_off() -> void:
	if grabbed_meter >= 0:
		grabbed_meter -= shake_off_strength
	else:
		is_grabbed = false
		grabbed_meter = 0.1


func get_grabbed() -> void:
	if grabbed_meter >= 1:
		die()
		return
	# The enemy increments the player's grabbed_meter by grab_strength for them
	# This is because I had a hard time preventing grabbed_meter from going up
	# 	when an enemy is flicked after grabbing
#	if is_grabbed:
#		grabbed_meter += grab_strength


func _on_grab_area_body_entered(body: Node2D) -> void:
	if body is Enemy:
		is_grabbed = true
		grab_sound_player.play()
	elif body.name.contains("Life"):
		body.queue_free()
		lives += 1
	elif body.name.contains("Fuel"):
		pass
	print(body.name)


func debug_restart() -> void:
	if can_use_debug_keys and Input.is_action_just_pressed("debug_restart"):
		get_tree().reload_current_scene()


func debug_increment_lives() -> void:
	if can_use_debug_keys and Input.is_action_just_pressed("debug_increment_lives"):
		lives += 1
		print(lives)


func debug_decrement_lives() -> void:
	if can_use_debug_keys and Input.is_action_just_pressed("debug_decrement_lives"):
		die()
		print(lives)


func debug_toggle_can_die() -> void:
	if can_use_debug_keys and Input.is_action_just_pressed("debug_toggle_can_die"):
		can_die = (not can_die)
		print("can_die?")
		print(can_die)


func _on_death_grace_period_timer_timeout() -> void:
	can_die = true


func shoot(delta: float) -> void:
	if can_shoot and Input.is_action_pressed("flick_index_finger") and Input.is_action_pressed("flick_thumb"):
		shoot_sound_player.play()
		shoot_cooldown_timer.start(shoot_cooldown)
		can_shoot = false
		var bullet = bullet_scene.instantiate()
		add_child(bullet)
		bullet.position = Vector2(20, -100)
		bullet.apply_impulse(shoot_vector * delta)


func _on_shoot_cooldown_timer_timeout() -> void:
	can_shoot = true


func reverse_scroll() -> void:
	if Input.is_action_just_pressed("reverse_scroll"):
		scroll_reversed.emit()
		
		if rocket_exhaust_is_visible:
			rocket_exhaust_sprite.hide()
			rocket_exhaust_is_visible = false
		else:
			rocket_exhaust_sprite.show()
			rocket_exhaust_is_visible = true


func get_to_mouse_vector() -> Vector2:
	mouse_position = get_global_mouse_position()
	return global_position.direction_to(mouse_position) * speed


func _on_grab_area_area_entered(area: Area2D) -> void:
	if area.name == "LifePickup":
		lives += 1
	if area.name == "FuelPickup":
		pass
