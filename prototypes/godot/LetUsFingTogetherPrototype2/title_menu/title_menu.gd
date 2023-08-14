extends CenterContainer


@export var level_path: String
@export var credits_path: String
@export var settings_path: String

@onready var start_button: Button = %StartButton


func _ready() -> void:
	MenuMusicPlayer.play(MenuMusicPlayer.last_playback_position)
	RenderingServer.set_default_clear_color(Color.DIM_GRAY)
	start_button.grab_focus()


func _on_start_button_pressed() -> void:
	MenuMusicPlayer.stop()
	get_tree().change_scene_to_file(level_path)


func _on_credits_button_pressed() -> void:
	MenuMusicPlayer.save_playback_position()
	get_tree().change_scene_to_file(credits_path)


func _on_settings_button_pressed() -> void:
	MenuMusicPlayer.save_playback_position()
	get_tree().change_scene_to_file(settings_path)


func _on_quit_button_pressed() -> void:
	get_tree().quit()
