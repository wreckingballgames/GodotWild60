extends AudioStreamPlayer


@onready var last_playback_position: float = MenuMusicPlayer.get_playback_position()


func save_playback_position() -> void:
	last_playback_position = MenuMusicPlayer.get_playback_position()
