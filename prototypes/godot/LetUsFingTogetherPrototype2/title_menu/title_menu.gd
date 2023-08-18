extends CenterContainer


@export var level: PackedScene = preload("res://intro_screen/intro_screen.tscn")
@export var credits: PackedScene = preload("res://credits_screen/credits_screen.tscn")
@export var controls: PackedScene = preload("res://settings_menu/controls_menu.tscn")

@onready var start_button: Button = %StartButton


func _ready() -> void:
	MenuMusicPlayer.play(MenuMusicPlayer.last_playback_position)
#	RenderingServer.set_default_clear_color(Color.DIM_GRAY)
	start_button.grab_focus()


func _on_start_button_pressed() -> void:
	MenuMusicPlayer.stop()
	MenuMusicPlayer.last_playback_position = 0.0
	get_tree().change_scene_to_packed(level)


func _on_credits_button_pressed() -> void:
	MenuMusicPlayer.save_playback_position()
	get_tree().change_scene_to_packed(credits)


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_controls_button_pressed() -> void:
	MenuMusicPlayer.save_playback_position()
	get_tree().change_scene_to_packed(controls)
