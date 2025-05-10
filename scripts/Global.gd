#Global.gd
extends Node

var silenced := false  # Default: Music stopped
var muted := false  # Default: Sound stopped
var dark_mode := true  # Default: Dark Mode
signal reset_game

@export var audio_player: AudioStreamPlayer2D
var volume_levels = [1.0, 0.0, 0.33, 0.66]  # 1.0 = full, 0.0 = mute
var current_level = 0
func toggle_music():
	if !audio_player:
		push_error("Global.gd: audio_player is null. Did GameManager assign it?")
		return
	match current_level:
		0: audio_player.volume_db = -80.0  # Mute
		1: audio_player.volume_db = -10.0  # 33%
		2: audio_player.volume_db = -5.0   # 66%
		3: audio_player.volume_db = 0.0    # 100%
	current_level = (current_level + 1) % 4
#	audio_player.volume_db = linear_to_db(volume_levels[current_level])
#	current_level = (current_level + 1) % volume_levels.size()
#	emit_signal("music_changed", volume_levels[current_level] == 0.0)
	print("music_changed ", current_level)

func toggle_sound():
	muted = !muted
	AudioManager.toggle_sfx_mute(muted)   # Mute SFX
	emit_signal("sound_changed", muted)

func toggle_theme():
	dark_mode = !dark_mode
	emit_signal("theme_changed", dark_mode)  # Emit signal with new state

func reset():
	emit_signal("reset_game")

signal music_changed(is_silenced)
signal sound_changed(is_muted)
signal theme_changed(is_dark_mode)
