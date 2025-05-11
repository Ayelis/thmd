#Global.gd
extends Node

var dark_mode := true  # Default: Dark Mode
signal reset_game

var music_volume_levels := [-80.0, -10.0, -5.0, 0.0]  # Mute, 33%, 66%, 100%
var current_volume_index := 3  # Start at 100% volume
var silenced := false  # Default: Music stopped
var muted := false  # Default: Sound stopped

signal music_changed(is_silenced: bool)
signal sound_changed(is_muted: bool)
signal theme_changed(is_dark_mode: bool)

func toggle_music():
	if silenced:
		# If currently silenced, unmute at last volume level
		silenced = false
		AudioManager.toggle_music_mute(false)
		current_volume_index = (current_volume_index + 1) % music_volume_levels.size()
		AudioManager.music_player.volume_db = music_volume_levels[current_volume_index]
	else:
		# Cycle through volume levels
		current_volume_index = (current_volume_index + 1) % music_volume_levels.size()
		if current_volume_index == 0:
			# If we reached mute level, set silenced flag
			silenced = true
		AudioManager.music_player.volume_db = music_volume_levels[current_volume_index]
	music_changed.emit(silenced)
	print("Music volume: ", music_volume_levels[current_volume_index], " dB (Silenced: ", silenced, ")")

func toggle_sound():
	muted = !muted
	AudioManager.toggle_sfx_mute(muted)
	sound_changed.emit(muted)
	print("SFX muted: ", muted)

func toggle_theme():
	dark_mode = !dark_mode
	emit_signal("theme_changed", dark_mode)  # Emit signal with new state

func reset():
	emit_signal("reset_game")
