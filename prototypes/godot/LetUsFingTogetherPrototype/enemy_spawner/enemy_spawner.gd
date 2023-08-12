extends RigidBody2D


@export var scroll_speed: float = 5000

@onready var scroll_vector: Vector2 = Vector2.LEFT * scroll_speed
@onready var enemy := preload("res://enemy/enemy.tscn")
@onready var enemy_container := $EnemyContainer
@onready var spawn_timer: Timer = $SpawnTimer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _physics_process(delta: float) -> void:
	apply_force(scroll_vector * delta)


func _on_spawn_timer_timeout() -> void:
	# Check if in bounds and spawn enemy if so
	var screen_position: Vector2 = get_viewport_rect().position
	var screen_end: Vector2 = get_viewport_rect().end
	if global_position.x > screen_position.x or global_position.x < screen_end.x:
		var enemy_instance := enemy.instantiate()
		enemy_instance.global_position = global_position
		enemy_container.add_child(enemy_instance)
