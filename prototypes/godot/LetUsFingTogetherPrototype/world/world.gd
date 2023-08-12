extends Node2D


var parallax_scroll: float = 0
@export var parallax_scroll_speed: float = 200

@onready var parallax_layer_1 := $ParallaxBackground/ParallaxLayer
@onready var parallax_layer_2 := $ParallaxBackground/ParallaxLayer2


func _process(delta: float) -> void:
	# Scroll background
	parallax_scroll -= parallax_scroll_speed * delta
	parallax_layer_1.motion_offset.x = parallax_scroll
	parallax_layer_2.motion_offset.x = parallax_scroll / 2
