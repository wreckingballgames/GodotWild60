extends CenterContainer


@export var first_level: PackedScene = preload("res://world/world.tscn")

@onready var label: Label = %Label
@onready var logo: Sprite2D = %Logo


func _ready() -> void:
	label.visible_ratio = 0
	logo.hide()


func _process(delta: float) -> void:
	if Input.is_anything_pressed():
		get_tree().change_scene_to_packed(first_level)
	if label.visible_ratio < 1:
		label.visible_ratio += .1 * delta
	else:
		await get_tree().create_timer(1.5).timeout
		logo.show()
		label.hide()
		await get_tree().create_timer(3.0).timeout
		get_tree().change_scene_to_packed(first_level)
