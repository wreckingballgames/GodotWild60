extends Node2D


var is_paused: bool = false

# Parallax Members
var parallax_scroll: float = 0
@export var parallax_scroll_speed: float = 200
@onready var parallax_layer_1 := $ParallaxBackground/ParallaxLayer # Starfield background
@onready var parallax_layer_2 := $ParallaxBackground/ParallaxLayer2 # Starfield foreground

@onready var pause_menu: CenterContainer = %PauseMenu


func _ready() -> void:
	RenderingServer.set_default_clear_color(Color.WEB_GRAY)


func _process(delta: float) -> void:
	pause()
	parallax_scrolling(delta)


func parallax_scrolling(delta: float) -> void:
	if not is_paused:
		# Scroll background
		parallax_scroll += parallax_scroll_speed * delta
		parallax_layer_1.motion_offset.y = parallax_scroll / 2
		parallax_layer_2.motion_offset.y = parallax_scroll


func _on_death_zone_body_entered(body: Node2D) -> void:
	body.queue_free()


func pause() -> void:
	if is_paused and Input.is_action_just_pressed("pause"):
		get_tree().paused = false
		is_paused = false
		pause_menu.hide()
	elif not is_paused and Input.is_action_just_pressed("pause"):
		get_tree().paused = true
		is_paused = true
		pause_menu.show()


func _on_pause_menu_unpaused() -> void:
	get_tree().paused = false
	is_paused = false
	pause_menu.hide()
