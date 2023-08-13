extends CenterContainer

signal unpaused

@export var title_path: String

@onready var unpause_button: Button = %UnpauseButton


func _ready() -> void:
	RenderingServer.set_default_clear_color(Color.DIM_GRAY)
	unpause_button.grab_focus()


func _on_unpause_button_pressed() -> void:
	emit_signal("unpaused")


func _on_return_button_pressed() -> void:
	get_tree().change_scene_to_file(title_path)


func _on_quit_button_pressed() -> void:
	get_tree().quit()
