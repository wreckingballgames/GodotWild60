extends RigidBody2D


var is_dead: bool = false

@onready var player := get_tree().get_first_node_in_group("Player")
@onready var enemy := preload("res://enemy/enemy.tscn")
@onready var enemy_container := $EnemyContainer
@onready var spawn_timer: Timer = $SpawnTimer
@onready var death_sound_player: AudioStreamPlayer = %DeathSoundPlayer
@onready var screen_size: Vector2 = get_viewport_rect().size
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var explosion_sprite: Sprite2D = $ExplosionSprite


func _ready() -> void:
	collision_shape_2d.disabled = true
	explosion_sprite.hide()


func _process(delta: float) -> void:
	player = get_tree().get_first_node_in_group("Player")


func _on_spawn_timer_timeout() -> void:
	# Check if in bounds and spawn enemy if so
	if player and not is_dead:
		if (global_position.y > 0 and global_position.y < screen_size.y) and global_position.y <= player.global_position.y:
			var enemy_instance := enemy.instantiate()
			enemy_instance.global_position = global_position
			enemy_container.add_child(enemy_instance)


func die() -> void:
	if not is_dead:
		set_collision_mask_value(2, true)
		set_collision_mask_value(3, true)
		set_collision_mask_value(5, true)
		death_sound_player.play()
		explosion_sprite.show()
		animation_player.play("die")
		is_dead = true


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	collision_shape_2d.disabled = false


func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.name == "FingerArea" and not is_dead:
		die()
