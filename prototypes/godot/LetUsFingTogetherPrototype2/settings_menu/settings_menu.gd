extends CenterContainer


@export var title_path: String

@onready var return_button: Button = %ReturnButton


func _ready() -> void:
	MenuMusicPlayer.play(MenuMusicPlayer.last_playback_position)
	RenderingServer.set_default_clear_color(Color.DIM_GRAY)
	return_button.grab_focus()


func _on_return_button_pressed() -> void:
	MenuMusicPlayer.save_playback_position()
	get_tree().change_scene_to_file(title_path)


func _on_quit_button_pressed() -> void:
	get_tree().quit()
