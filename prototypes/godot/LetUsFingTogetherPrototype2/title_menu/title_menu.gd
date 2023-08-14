extends CenterContainer


@export var level_path: String
@export var credits_path: String
@export var settings_path: String

@onready var start_button: Button = %StartButton
@onready var music_player: AudioStreamPlayer = %MusicPlayer


func _ready() -> void:
	RenderingServer.set_default_clear_color(Color.DIM_GRAY)
	start_button.grab_focus()


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file(level_path)


func _on_credits_button_pressed() -> void:
	get_tree().change_scene_to_file(credits_path)


func _on_settings_button_pressed() -> void:
	get_tree().change_scene_to_file(settings_path)


func _on_quit_button_pressed() -> void:
	get_tree().quit()
