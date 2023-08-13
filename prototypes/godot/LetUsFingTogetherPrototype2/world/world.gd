extends Node2D


# Parallax Members
var parallax_scroll: float = 0
@export var parallax_scroll_speed: float = 200
@onready var parallax_layer_1 := $ParallaxBackground/ParallaxLayer # Starfield background
@onready var parallax_layer_2 := $ParallaxBackground/ParallaxLayer2 # Starfield foreground


func _ready() -> void:
	RenderingServer.set_default_clear_color(Color.WEB_GRAY)


func _process(delta: float) -> void:
	parallax_scrolling(delta)


func parallax_scrolling(delta: float) -> void:
	# Scroll background
	parallax_scroll += parallax_scroll_speed * delta
	parallax_layer_1.motion_offset.y = parallax_scroll / 2
	parallax_layer_2.motion_offset.y = parallax_scroll


func _on_death_zone_body_entered(body: Node2D) -> void:
	body.queue_free()
