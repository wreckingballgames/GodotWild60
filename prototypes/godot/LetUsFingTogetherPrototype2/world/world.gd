extends Node2D


var is_paused: bool = false

@export var next_level: PackedScene
@export var game_over_screen: PackedScene = preload("res://game_over_screen/game_over_screen.tscn")

@onready var pause_menu: CenterContainer = %PauseMenu
@onready var time_remaining_label: Label = %TimeRemainingLabel
@onready var game_timer: Timer = %GameTimer
@onready var lives_label: Label = %LivesLabel
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("Player")
@onready var fuel_label: Label = %FuelLabel

# Scrolling members
@onready var enemies: Array[Node] = get_tree().get_nodes_in_group("Enemy")
@export var enemy_scroll_speed: float = 2000
@onready var enemy_scroll_vector: Vector2 = Vector2.DOWN * enemy_scroll_speed

@onready var obstacles: Array[Node] = get_tree().get_nodes_in_group("Obstacle")
@export var obstacle_scroll_speed: float = 2000
@onready var obstacle_scroll_vector: Vector2 = Vector2.DOWN * obstacle_scroll_speed

@onready var enemy_spawners: Array[Node] = get_tree().get_nodes_in_group("EnemySpawner")
@export var enemy_spawner_scroll_speed = 2000
@onready var enemy_spawner_scroll_vector: Vector2 = Vector2.DOWN * enemy_spawner_scroll_speed

@onready var pickups: Array[Node] = get_tree().get_nodes_in_group("Pickup")
@export var pickup_scroll_speed = 2000
@onready var pickup_scroll_vector: Vector2 = Vector2.DOWN * pickup_scroll_speed

# Parallax Members
var parallax_scroll: float = 0
@export var parallax_scroll_speed: float = 200
@onready var parallax_layer_1 := $ParallaxBackground/ParallaxLayer # Starfield background
@onready var parallax_layer_2 := $ParallaxBackground/ParallaxLayer2 # Starfield foreground


func _physics_process(delta: float) -> void:
	enemies = get_tree().get_nodes_in_group("Enemy")
	obstacles = get_tree().get_nodes_in_group("Obstacle")
	enemy_spawners = get_tree().get_nodes_in_group("EnemySpawner")
	pickups = get_tree().get_nodes_in_group("Pickup")
	scroll(delta)


func _process(delta: float) -> void:
	player = get_tree().get_first_node_in_group("Player")
	if player:
		lives_label.text = str(player.lives)
		fuel_label.text = "Fuel left: " + str(floor(player.fuel))
	else:
		get_tree().change_scene_to_packed(game_over_screen)
	handle_pause()
	parallax_scrolling(delta)
	time_remaining_label.text = "Survive for: " + str(floorf(game_timer.time_left))


func parallax_scrolling(delta: float) -> void:
	if not is_paused:
		# Scroll background
		parallax_scroll += parallax_scroll_speed * delta
		parallax_layer_1.motion_offset.y = parallax_scroll / 2
		parallax_layer_2.motion_offset.y = parallax_scroll


func _on_death_zone_body_entered(body: Node2D) -> void:
	body.queue_free()


func handle_pause() -> void:
	if is_paused and Input.is_action_just_pressed("pause"):
		get_tree().paused = false
		is_paused = false
		pause_menu.hide()
	elif not is_paused and Input.is_action_just_pressed("pause"):
		get_tree().paused = true
		is_paused = true
		pause_menu.show()
		pause_menu.get_node("VBoxContainer/UnpauseButton").grab_focus()


func _on_pause_menu_unpaused() -> void:
	get_tree().paused = false
	is_paused = false
	pause_menu.hide()


func _on_game_timer_timeout() -> void:
	if next_level:
		get_tree().change_scene_to_packed(next_level)


func scroll(delta: float) -> void:
	for enemy in enemies:
		enemy.apply_force(enemy_scroll_vector * delta)
	for obstacle in obstacles:
		obstacle.apply_force(obstacle_scroll_vector * delta)
	for enemy_spawner in enemy_spawners:
		enemy_spawner.apply_force(enemy_spawner_scroll_vector * delta)
	for pickup in pickups:
		pickup.apply_force(pickup_scroll_vector * delta)


func _on_player_scroll_reversed() -> void:
	enemy_scroll_vector *= -1
	obstacle_scroll_vector *= -1
	enemy_spawner_scroll_vector *= -1
	parallax_scroll_speed *= -1
