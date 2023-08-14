extends RigidBody2D


var is_dead: bool = false

@export var scroll_speed: float = 4000

@onready var player := get_tree().get_first_node_in_group("Player")
@onready var scroll_vector: Vector2 = Vector2.DOWN * scroll_speed
@onready var enemy := preload("res://enemy/enemy.tscn")
@onready var enemy_container := $EnemyContainer
@onready var spawn_timer: Timer = $SpawnTimer
@onready var death_sound_player: AudioStreamPlayer = %DeathSoundPlayer


func _physics_process(delta: float) -> void:
	apply_force(scroll_vector * delta)


func _process(delta: float) -> void:
	player = get_tree().get_first_node_in_group("Player")


func _on_spawn_timer_timeout() -> void:
	# Check if in bounds and spawn enemy if so
	var screen_position: Vector2 = get_viewport_rect().position
	var screen_end: Vector2 = get_viewport_rect().end
	if player != null:
		if (global_position.y > screen_position.y or global_position.y < screen_end.x) and global_position.y <= player.global_position.y:
			var enemy_instance := enemy.instantiate()
			enemy_instance.global_position = global_position
			enemy_container.add_child(enemy_instance)


func die() -> void:
	death_sound_player.play()
	is_dead = true


func _on_body_entered(body: Node) -> void:
	die()
