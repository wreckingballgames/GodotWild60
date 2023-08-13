extends CenterContainer


@export var level_path: String

@onready var start_button: Button = %StartButton
@onready var credits_button: Button = %CreditsButton
@onready var settings_button: Button = %SettingsButton
@onready var quit_button: Button = %QuitButton


func _ready() -> void:
	start_button.grab_focus()


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file(level_path)


func _on_credits_button_pressed() -> void:
	pass # Replace with function body.


func _on_settings_button_pressed() -> void:
	pass # Replace with function body.


func _on_quit_button_pressed() -> void:
	get_tree().quit()
