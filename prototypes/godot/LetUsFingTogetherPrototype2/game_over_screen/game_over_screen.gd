extends CenterContainer


@onready var title_menu: PackedScene = preload("res://title_menu/title_menu.tscn")


func _on_return_button_pressed() -> void:
	get_tree().change_scene_to_packed(title_menu)


func _on_quit_button_pressed() -> void:
	get_tree().quit()
