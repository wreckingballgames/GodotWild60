extends RigidBody2D


var is_dead: bool = false

@onready var player := get_tree().get_first_node_in_group("Player")
@onready var enemy := preload("res://enemy/enemy.tscn")
@onready var enemy_container := $EnemyContainer
@onready var spawn_timer: Timer = $SpawnTimer
@onready var death_sound_player: AudioStreamPlayer = %DeathSoundPlayer
@onready var screen_size: Vector2 = get_viewport_rect().size


func _process(delta: float) -> void:
	player = get_tree().get_first_node_in_group("Player")


func _on_spawn_timer_timeout() -> void:
	# Check if in bounds and spawn enemy if so
	if player:
		if (global_position.y > 0 and global_position.y < screen_size.y) and global_position.y <= player.global_position.y:
			var enemy_instance := enemy.instantiate()
			enemy_instance.global_position = global_position
			enemy_container.add_child(enemy_instance)


func die() -> void:
	death_sound_player.play()
	is_dead = true


func _on_body_entered(body: Node) -> void:
	die()
